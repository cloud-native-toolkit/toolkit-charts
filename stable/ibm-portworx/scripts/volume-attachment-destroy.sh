#!/bin/bash

NODE_NAME="$1"
RESOURCE_GROUP_ID="$2"

if [[ -z "${NODE_NAME}" ]] || [[ -z "${RESOURCE_GROUP_ID}" ]]; then
  echo "usage: attach-volume.sh NODE_NAME RESOURCE_GROUP_ID" >&2
  exit 1
fi

if [[ -z "${IBMCLOUD_API_KEY}" ]]; then
  echo "IBMCLOUD_API_KEY must be provided as an environment variable" >&2
  exit 1
fi

if ! command -v curl 1> /dev/null 2> /dev/null; then
  echo "curl command not found" >&2
  exit 1
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq command not found" >&2
  exit 1
fi

if ! command -v kubectl 1> /dev/null 2> /dev/null; then
  echo "kubectl command not found" >&2
  exit 1
fi

REGION=$(kubectl get node "${NODE_NAME}" -o json | jq -r '.metadata.labels["ibm-cloud.kubernetes.io/region"]')
WORKER_ID=$(kubectl get node "${NODE_NAME}" -o json | jq -r '.metadata.labels["ibm-cloud.kubernetes.io/worker-id"]')
PROVIDER_ID=$(kubectl get node "${NODE_NAME}" -o json | jq -r '.spec.providerID')
CLUSTER_ID=$(echo "${PROVIDER_ID}" | sed -E 's~ibm://.*/([^/]+)/.+~\1~g')

NAME="pwx-${WORKER_ID}"

export TOKEN=$(curl -s -X POST "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=${IBMCLOUD_API_KEY}" | jq -r '.access_token')

API_VERSION="2021-04-06"

VOLUME_ID=$(curl -X GET "https://${REGION}.iaas.cloud.ibm.com/v1/volumes?version=${API_VERSION}&generation=2" \
  -H "Authorization: ${TOKEN}" | \
  jq -r --arg NAME "${NAME}" '.volumes[] | select(.name == $NAME) | .id // empty')

echo "Detaching volume $VOLUME_ID from worker $WORKER_ID"

# Grab volume attachment id
if ! RESPONSE=$(
    curl -s -X GET -H "Authorization: $TOKEN" \
        -H "Content-Type: application/json" \
        -H "X-Auth-Resource-Group-ID: $RESOURCE_GROUP_ID" \
        "https://$REGION.containers.cloud.ibm.com/v2/storage/getAttachments?cluster=$CLUSTER_ID&worker=$WORKER_ID"
); then
  echo 'Error when trying to /getAttachments' >&2
  exit 1
fi

ID=$(echo "${RESPONSE}" | jq -r --arg VOLUMEID "$VOLUME_ID" '.volume_attachments[] | select(.volume.id==$VOLUMEID) | .id // empty')

if [[ -z "${ID}" ]]; then
    echo "No attachment found, skipping"
else
    echo "Deleting volume attachment $ID"
    if ! curl -s -X DELETE -H "Authorization: $TOKEN" \
        "https://$REGION.containers.cloud.ibm.com/v2/storage/vpc/deleteAttachment?cluster=$CLUSTER_ID&worker=$WORKER_ID&volumeAttachmentID=$ID"; then
      echo 'Delete failed' >&2
      exit 1
    fi
    echo 'Sleeping for 30s...'
    sleep 30
fi
