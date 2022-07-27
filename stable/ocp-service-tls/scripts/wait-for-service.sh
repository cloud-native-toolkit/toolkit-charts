#!/usr/bin/env bash

if [[ -z "${SERVICE}" ]] || [[ -z "${NAMESPACE}" ]]; then
  echo "SERVICE and NAMESPACE are required environment variables" >&2
  exit 1
fi

if ! command -v oc 1> /dev/null 2> /dev/null; then
  echo "oc cli not found" >&2
  exit 1
fi

count=0
echo "Checking for service: ${NAMESPACE}/${SERVICE}"
echo ""
until oc get service "${SERVICE}" -n "${NAMESPACE}" 1> /dev/null || [[ "${count}" -eq 20 ]]; do
  echo "  Waiting 30 seconds for service: ${NAMESPACE}/${SERVICE}"
  count=$((count + 1))
  sleep 30
done

if [[ "${count}" -eq 20 ]]; then
  echo "Timed out waiting for service: ${NAMESPACE}/${SERVICE}" >&2
  exit 1
fi

echo "*** The service has been created: ${NAMESPACE}/${SERVICE}"
