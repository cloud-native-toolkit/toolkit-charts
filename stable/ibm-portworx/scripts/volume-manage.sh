#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

if [[ -z "${NODE_NAME}" ]] || [[ -z "${RESOURCE_GROUP_ID}" ]]; then
  echo "NODE_NAME and RESOURCE_GROUP_ID should be provided as environment variables" >&2
  exit 1
fi

NODE_JSON=$(kubectl get node "${NODE_NAME}" -o json)

REGION=$(echo "${NODE_JSON}" | jq -r '.metadata.labels["ibm-cloud.kubernetes.io/region"]')
WORKER_ID=$(echo "${NODE_JSON}" | jq -r '.metadata.labels["ibm-cloud.kubernetes.io/worker-id"]')
PROVIDER_ID=$(echo "${NODE_JSON}" | jq -r '.spec.providerID')
CLUSTER_ID=$(echo "${PROVIDER_ID}" | sed -E 's~ibm://.*/([^/]+)/.+~\1~g')

echo "Node values: region=${REGION}, workerId=${WORKER_ID}, clusterId=${CLUSTER_ID}"

exit_script() {
    echo "SIGTERM received!"
    echo "Cleaning up volume attachment"
    "${SCRIPT_DIR}/volume-attachment-destroy.sh" "${RESOURCE_GROUP_ID}" "${REGION}" "${WORKER_ID}" "${CLUSTER_ID}"
    EXIT="true"
}

trap exit_script SIGINT SIGTERM

"${SCRIPT_DIR}/volume-attach.sh" "${RESOURCE_GROUP_ID}" "${REGION}" "${WORKER_ID}" "${CLUSTER_ID}"

while [[ "${EXIT}" != "true" ]]; do sleep 10; done
