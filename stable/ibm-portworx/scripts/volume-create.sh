#!/usr/bin/env bash

NODE_NAME="$1"
RESOURCE_GROUP_ID="$2"

if [[ -z "${NODE_NAME}" ]] || [[ -z "${RESOURCE_GROUP_ID}" ]]; then
  echo "usage: create-volume.sh NODE_NAME RESOURCE_GROUP_ID" >&2
  exit 1
fi

if [[ -z "${IBMCLOUD_API_KEY}" ]]; then
  echo "IBMCLOUD_API_KEY must be provided as an environment variable" >&2
  exit 1
fi

if ! command -v curl 1> /dev/null 2> /dev/null; then
  echo "curl command not found" > &2
  exit 1
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq command not found" > &2
  exit 1
fi

if ! command -v kubectl 1> /dev/null 2> /dev/null; then
  echo "kubectl command not found" > &2
  exit 1
fi

## Lookup zone and resource group from the cluster
REGION=$(kubectl get node "${NODE_NAME}" -o json | jq -r '.metadata.labels["ibm-cloud.kubernetes.io/region"]')
ZONE=$(kubectl get node "${NODE_NAME}" -o json | jq -r '.metadata.labels["ibm-cloud.kubernetes.io/zone"]')
WORKER_ID=$(kubectl get node "${NODE_NAME}" -o json | jq -r '.metadata.labels["ibm-cloud.kubernetes.io/worker-id"]')

NAME="pwx-${WORKER_ID}"

if [[ -z "${IOPS}" ]]; then
  IOPS="100"
  echo "IOPS environment variable not provided. Defaulting to '${IOPS}'"
fi
if [[ -z "${CAPACITY}" ]]; then
  CAPACITY="50"
  echo "CAPACITY environment variable not provided. Defaulting to '${CAPACITY}'"
fi
if [[ -z "${PROFILE}" ]]; then
  PROFILE="custom"
  echo "PROFILE environment variable not provided. Defaulting to '${PROFILE}'"
fi
if [[ -z "${ENCRYPTION_KEY}" ]]; then
  echo "ENCRYPTION_KEY environment variable not provided. The volume won't be encrypted with KMS."
fi

jq -n \
  --arg NAME "${NAME}" \
  --arg ZONE "${ZONE}" \
  --arg RESOURCE_GROUP_ID "${RESOURCE_GROUP_ID}" \
  --arg IOPS "${IOPS}" \
  --arg CAPACITY "${CAPACITY}" \
  --arg PROFILE "${PROFILE}" \
  '{"name": $NAME, "iops": $IOPS, "capacity": $CAPACITY, "zone": {"name": $ZONE}, "profile": {"name": $PROFILE}, "resource_group": {"id": $RESOURCE_GROUP_ID}}' > /tmp/volume-request.json

if [[ -n "${ENCRYPTION_KEY}" ]]; then
  cat /tmp/volume-request.json | jq --arg ENCRYPTION_KEY "${ENCRYPTION_KEY}" \
    '.encryption_key = {"crn": $ENCRYPTION_KEY}' > /tmp/volume-request.json.bak && \
    cp /tmp/volume-request.json.bak /tmp/volume-request.json && \
    rm /tmp/volume-request.json.bak
fi

VPC_API_ENDPOINT="https://${REGION}.iaas.cloud.ibm.com"
API_VERSION="2021-04-06"

export TOKEN=$(curl -s -X POST "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=${IBMCLOUD_API_KEY}" | jq -r '.access_token')


## Check if volume already exists
VOLUME_ID=$(curl -X GET "${VPC_API_ENDPOINT}/v1/volumes?version=${API_VERSION}&generation=2" \
  -H "Authorization: $TOKEN" | \
  jq -r --arg NAME "${NAME}" '.volumes[] | select(.name == $NAME) | .id // empty')

if [[ -n "${VOLUME_ID}" ]]; then
  echo "Volume already exists: ${NAME}"
  exit 0
fi

curl -X POST "${VPC_API_ENDPOINT}/v1/volumes?version=${API_VERSION}&generation=2" \
  -H "Authorization: $TOKEN" \
  -d @/tmp/volume-request.json
