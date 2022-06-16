#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

RESOURCE_GROUP_ID="$1"
REGION="$2"
WORKER_ID="$3"
CLUSTER_ID="$4"
VOLUME_SUFFIX="$5"

if [[ -z "${RESOURCE_GROUP_ID}" ]] || [[ -z "${REGION}" ]] ||  [[ -z "${WORKER_ID}" ]] || [[ -z "${CLUSTER_ID}" ]]; then
  echo "usage: volume-attachment-destroy.sh RESOURCE_GROUP_ID REGION WORKER_ID CLUSTER_ID" >&2
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

source "${SCRIPT_DIR}/support-functions.sh"

NAME=$(volume_name "${WORKER_ID}" "${VOLUME_SUFFIX}")

get_token "${IBMCLOUD_API_KEY}"

get_volume_id "${REGION}" "${NAME}"

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
