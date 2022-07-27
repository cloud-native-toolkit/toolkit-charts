#!/usr/bin/env bash

if [[ -z "${SERVICE}" ]] || [[ -z "${NAMESPACE}" ]] || [[ -z "${SECRET_NAME}" ]]; then
  echo "SERVICE, NAMESPACE and SECRET_NAME are required environment variables" >&2
  exit 1
fi

if ! command -v oc 1> /dev/null 2> /dev/null; then
  echo "oc cli not found" >&2
  exit 1
fi

echo "Adding annotation to service (${SERVICE}): service.beta.openshift.io/serving-cert-secret-name=${SECRET_NAME}"
oc annotate service "${SERVICE}" -n "${NAMESPACE}" --overwrite=true \
     "service.beta.openshift.io/serving-cert-secret-name=${SECRET_NAME}"

if [[ -z "${CA_CONFIG_MAP_NAME}" ]]; then
  echo "No configmap configuration provided. Exiting..."
  exit 0
fi

echo "Creating configmap for ca certificate: ${CA_CONFIG_MAP_NAME}"
oc create configmap "${CA_CONFIG_MAP_NAME}" -n "${NAMESPACE}" --dry-run=client --output=json --from-literal=test=replaceme | \
  oc annotate -f - service.beta.openshift.io/inject-cabundle=true --local=true --dry-run=client --output=json | \
  oc apply -f -
