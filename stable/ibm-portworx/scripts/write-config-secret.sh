#!/usr/bin/env bash

NODE_NAME="$1"
NAMESPACE="$2"
SECRET_NAME="$3"

PROVIDER_ID=$(oc get node "${NODE_NAME}" -o json | jq -r '.spec.providerID')
CLUSTER_ID=$(echo "${PROVIDER_ID}" | sed -E 's~ibm://.*/([^/]+)/.+~\1~g')

kubectl create secret generic "${SECRET_NAME}" \
  --from-literal="clusterId=${CLUSTER_ID}" \
  --dry-run=client \
  --output=json | \
  kubectl apply -n "${NAMESPACE}" -f -
