#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)
SUPPORT_DIR=$(cd "${SCRIPT_DIR}/../support"; pwd -P)
TEMPLATE_DIR=$(cd "${SCRIPT_DIR}/../templates"; pwd -P)

cat "${SUPPORT_DIR}/configmap.snippet.yaml" > "${TEMPLATE_DIR}/configmap.yaml"

oc create configmap tmp \
  --from-file="${SCRIPT_DIR}/volume-create.sh" \
  --from-file="${SCRIPT_DIR}/volume-attach.sh" \
  --from-file="${SCRIPT_DIR}/volume-attachment-destroy.sh" \
  --from-file="${SCRIPT_DIR}/volume-manage.sh" \
  --from-file="${SCRIPT_DIR}/write-config-secret.sh" \
  --from-file="${SCRIPT_DIR}/support-functions.sh" \
  --dry-run=client \
  -o yaml | \
yq eval 'del(.apiVersion) | del(.kind) | del(.metadata)' - >> "${TEMPLATE_DIR}/configmap.yaml"


cat "${SUPPORT_DIR}/configmap-delete.snippet.yaml" > "${TEMPLATE_DIR}/post-delete-hook-config.yaml"

oc create configmap tmp \
  --from-file="${SCRIPT_DIR}/wipe_portworx.sh" \
  --dry-run=client \
  -o yaml | \
yq eval 'del(.apiVersion) | del(.kind) | del(.metadata)' - >> "${TEMPLATE_DIR}/post-delete-hook-config.yaml"
