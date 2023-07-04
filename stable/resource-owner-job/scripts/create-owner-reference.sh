#!/usr/bin/env bash

if [[ -z "${OWNER_KIND}" ]]; then
  OWNER_KIND="$1"

  if [[ -z "${OWNER_KIND}" ]]; then
    echo "OWNER_KIND env value not found" >&2
    exit 1
  fi
fi

if [[ -z "${OWNER_NAME}" ]]; then
  OWNER_NAME="$2"

  if [[ -z "${OWNER_NAME}" ]]; then
    echo "OWNER_NAME env value not found" >&2
    exit 1
  fi
fi

if [[ -z "${TARGET_KIND}" ]]; then
  TARGET_KIND="$3"

  if [[ -z "${TARGET_KIND}" ]]; then
    echo "TARGET_KIND env value not found" >&2
    exit 1
  fi
fi

if [[ -z "${TARGET_NAME}" ]]; then
  TARGET_NAME="$4"
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq not installed" >&2
  exit 1
fi

if ! command -v kubectl 1> /dev/null 2> /dev/null; then
  echo "kubectl not installed" >&2
  exit 1
fi

OWNER_DEF=$(kubectl get "${OWNER_KIND}/${OWNER_NAME}" -o json)

OWNER_KIND=$(echo "${OWNER_DEF}" | jq -r '.kind')
if [[ $(echo "${OWNER_KIND}" | tr '[:upper:]' '[:lower:]') == "subscription" ]] && [[ $(echo "${TARGET_KIND}" | tr '[:upper:]' '[:lower:]') == "clusterserviceversion" ]]; then
  TARGET_NAME=$(echo "${OWNER_DEF}" | jq -r '.status.currentCSV // empty')
elif [[ -z "${TARGET_NAME}" ]]; then
  echo "TARGET_NAME env value not found" >&2
  exit 1
fi

OWNER_REF=$(echo "${OWNER_DEF}" | jq '{"apiVersion": .apiVersion, "kind": .kind, "name": .metadata.name, "uid": .metadata.uid, "blockOwnerDeletion": true, "controller": true}')

PATCH=$(jq -n --argjson REF "${OWNER_REF}" '[{"op": "add", "path": "/metadata/ownerReferences", "value": [$REF]}]')

kubectl patch "${TARGET_KIND}/${TARGET_NAME}" \
  --type json \
  -p "${PATCH}"
