#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
SUPPORT_DIR=$(cd "${SCRIPT_DIR}/../support"; pwd -P)
TEMPLATE_DIR=$(cd "${SCRIPT_DIR}/../templates"; pwd -P)

if ! command -v oc 1> /dev/null 2> /dev/null; then
  echo "oc cli required" >&2
  exit 1
fi

if ! command -v yq 1> /dev/null 2> /dev/null; then
  echo "yq cli required" >&2
  exit 1
fi

cat "${SUPPORT_DIR}/configmap.snippet.yaml" > "${TEMPLATE_DIR}/configmap.yaml"

oc create configmap tmp \
  --from-file=${SCRIPT_DIR}/annotate-service.sh \
  --from-file=${SCRIPT_DIR}/wait-for-service.sh \
  --dry-run=client \
  -o yaml | \
yq eval 'del(.apiVersion) | del(.kind) | del(.metadata)' - >> "${TEMPLATE_DIR}/configmap.yaml"
