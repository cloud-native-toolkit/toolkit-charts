#!/usr/bin/env bash

if [[ -z "${PROVIDER_NAME}" ]]; then
  echo "PROVIDER_NAME is required as an environment variable" >&2
  exit 1
fi

PROVIDER_INDEX=$(oc get oauth cluster --output json | jq --arg NAME "${PROVIDER_NAME}" '.spec.identityProviders | map(.name == $NAME) | index(true) // empty')

if [[ -n "${PROVIDER_INDEX}" ]]; then
  oc patch oauth cluster --type json -p "[{\"op\": \"remove\", \"path\": \"/spec/identityProviders/${PROVIDER_INDEX}\"}]"
else
  echo "Warning: Index of ${PROVIDER_NAME} not found"
fi
