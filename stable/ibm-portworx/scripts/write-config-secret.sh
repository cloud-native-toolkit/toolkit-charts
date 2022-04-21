#!/usr/bin/env bash

NODE_NAME="$1"
NAMESPACE="$2"
SECRET_NAME="$3"

if [[ -z "${NODE_NAME}" ]] || [[ -z "${NAMESPACE}" ]] || [[ -z "${SECRET_NAME}" ]]; then
  echo "usage: write-config-secret.sh NODE_NAME NAMESPACE SECRET_NAME" >&2
  exit 1
fi

echo "Getting providerID from node: ${NODE_NAME}"

PROVIDER_ID=$(oc get node "${NODE_NAME}" -o json | jq -r '.spec.providerID')
CLUSTER_ID=$(echo "${PROVIDER_ID}" | sed -E 's~ibm://.*/([^/]+)/.+~\1~g')

echo "Found clusterId: ${CLUSTER_ID}"

echo "Creating secret: ${SECRET_NAME}"

kubectl create secret generic "${SECRET_NAME}" \
  --from-literal="clusterId=${CLUSTER_ID}" \
  --dry-run=client \
  --output=json | \
  kubectl apply -n "${NAMESPACE}" -f -

echo "Created secret: ${SECRET_NAME}"
