#!/bin/bash

if [[ -z "${SERVICE}" ]] || [[ -z "${NAMESPACE}" ]]; then
  echo "SERVICE and NAMESPACE are required environment variables" >&2
  exit 1
fi

csrName=${SERVICE}.${NAMESPACE}

if ! command -v oc 1> /dev/null 2> /dev/null; then
  echo "oc cli not found" >&2
  exit 1
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq cli not found" >&2
  exit 1
fi

# verify CSR has been created
while true; do
  if oc get csr ${csrName} 1> /dev/null 2> /dev/null; then
    echo "Found csr: ${csrName}"
    break
  fi
done

CSR_NAME=$(oc get csr ${csrName} -o json | jq -r 'select(.status == {} ) | .metadata.name')

echo "Unapproved csr: ${CSR_NAME}"

if [[ -n "${CSR_NAME}" ]]; then
  echo "Approving csr: ${CSR_NAME}"
  kubectl certificate approve "${CSR_NAME}"
fi
