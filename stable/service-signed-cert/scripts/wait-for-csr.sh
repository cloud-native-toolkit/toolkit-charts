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

while true; do
  echo "Getting certificate value from csr ${csrName}"
  serverCert=$(oc get csr ${csrName} -o jsonpath='{.status.certificate}')
  if [[ -n "${serverCert}" ]]; then
      break
  fi
  sleep 30
done

echo "*** The certificate has been approved - ${csrName}"
