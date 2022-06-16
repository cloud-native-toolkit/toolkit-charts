#!/usr/bin/env bash

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq command not found" >&2
  exit 1
fi

if ! command -v oc 1> /dev/null 2> /dev/null; then
  echo "oc command not found" >&2
  exit 1
fi

if [[ -z "${SERVICE_NAME}" ]]; then
  echo "SERVICE_NAME environment variable is required" >&2
  exit 1
fi

if [[ -z "${NAMESPACE}" ]]; then
  NAMESPACE="kube-system"
fi

SERVICE_JSON=$(oc get services.ibmcloud -n "${NAMESPACE}" "${SERVICE_NAME}" -o json)
SERVICE_UID=$(echo "${SERVICE_JSON}" | jq -r '.metadata.uid')
SERVICE_API_VERSION=$(echo "${SERVICE_JSON}" | jq -r '.apiVersion')
SERVICE_KIND=$(echo "${SERVICE_JSON}" | jq -r '.kind')

PATCH=$(jq -n -c \
  --arg UID "${SERVICE_UID}" \
  --arg API_VERSION "${SERVICE_API_VERSION}" \
  --arg KIND "${SERVICE_KIND}" \
  --arg NAME "${SERVICE_NAME}" \
  '{"metadata": {"ownerReferences": [{"apiVersion": $API_VERSION, "kind": $KIND, "uid": $UID, "name": $NAME}]}}')

oc get serviceaccount,service,configmap,job,deployment,daemonset,statefulset -n "${NAMESPACE}" -l app.kubernetes.io/instance=portworx -o json | \
jq -c '.items[] | {"name": .metadata.name, "kind": .kind}' | \
while read resource; do
  kind=$(echo "${resource}" | jq -r '.kind')
  name=$(echo "${resource}" | jq -r '.name')

  oc patch -n "${NAMESPACE}" "${kind}" "${name}" -p "${PATCH}"
done

if oc get deployment -n "${NAMESPACE}" portworx-pvc-controller 1> /dev/null 2> /dev/null; then
  oc get deployment -n "${NAMESPACE}" portworx-pvc-controller -o json | \
  jq -c '{"name": .metadata.name, "kind": .kind}' | \
  while read resource; do
    kind=$(echo "${resource}" | jq -r '.kind')
    name=$(echo "${resource}" | jq -r '.name')

    oc patch -n "${NAMESPACE}" "${kind}" "${name}" -p "${PATCH}"
  done
fi

if oc get sa -n "${NAMESPACE}" portworx-pvc-controller-account 1> /dev/null 2> /dev/null; then
  oc get sa -n "${NAMESPACE}" portworx-pvc-controller-account -o json | \
  jq -c '{"name": .metadata.name, "kind": .kind}' | \
  while read resource; do
    kind=$(echo "${resource}" | jq -r '.kind')
    name=$(echo "${resource}" | jq -r '.name')

    oc patch -n "${NAMESPACE}" "${kind}" "${name}" -p "${PATCH}"
  done
fi
