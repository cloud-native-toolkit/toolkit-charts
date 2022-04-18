#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

export NODE_NAME="$1"
export RESOURCE_GROUP_ID="$2"

exit_script() {
    echo "SIGTERM received!"
    echo "Cleaning up volume attachment"
    "${SCRIPT_DIR}/volume-attachment-destroy.sh" "${NODE_NAME}" "${RESOURCE_GROUP_ID}"
}

trap exit_script SIGTERM

"${SCRIPT_DIR}/volume-attach.sh" "${NODE_NAME}" "${RESOURCE_GROUP_ID}"

while true; do sleep 300; done
