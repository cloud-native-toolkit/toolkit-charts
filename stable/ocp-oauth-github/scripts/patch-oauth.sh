#!/usr/bin/env bash

cat /scripts/oauth-patch.yaml

PROVIDER=$(yq '.' /scripts/oauth-patch.yaml -o json | jq -c '.spec.identityProviders[]')

oc get oauth cluster -o json | \
  jq --argjson PROVIDER "${PROVIDER}" '.spec.identityProviders += [$PROVIDER]' | \
  oc apply -f -
