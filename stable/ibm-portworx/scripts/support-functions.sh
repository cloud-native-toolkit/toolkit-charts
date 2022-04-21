#!/usr/bin/env bash

API_VERSION="2021-04-06"

get_token() {
  local API_KEY="$1"

  TOKEN=$(curl -s -X POST "https://iam.cloud.ibm.com/identity/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=${API_KEY}" | jq -r '.access_token')

  if [[ -z "${TOKEN}" ]]; then
    echo "Error retrieving auth token" >&2
    exit 1
  fi
}

get_volume_id() {
  local REGION="$1"
  local NAME="$2"

  VOLUME_ID=$(curl -s -X GET "https://${REGION}.iaas.cloud.ibm.com/v1/volumes?version=${API_VERSION}&generation=2&name=${NAME}" \
    -H "Authorization: Bearer ${TOKEN}" | \
    jq -r --arg NAME "${NAME}" '.volumes[] | select(.name == $NAME) | .id // empty')
}

create_volume() {
  local REGION="$1"
  local NAME="$2"
  local DATA="$3"

  curl -s -X POST "https://${REGION}.iaas.cloud.ibm.com/v1/volumes?version=${API_VERSION}&generation=2" \
    -H "Authorization: Bearer $TOKEN" \
    -d "${DATA}"

  get_volume_id "${REGION}" "${NAME}"
}

wait_for_volume() {
  local REGION="$1"
  local VOLUME_ID="$2"

  echo "Waiting for volume to be ready: ${VOLUME_ID}"

  count=0
  STATUS="pending"
  while [[ "${STATUS}" == "pending" ]] || [[ $count -gt 20 ]]; do
    local VOLUME=$(curl -s -X GET "https://${REGION}.iaas.cloud.ibm.com/v1/volumes/${VOLUME_ID}?version=${API_VERSION}&generation=2" \
      -H "Authorization: Bearer ${TOKEN}" | jq -c '.')

    STATUS=$(echo "${VOLUME}" | jq -r '.status')

    if [[ "${STATUS}" == "pending" ]]; then
      echo "Volume is still pending. Sleeping for 30 seconds..."
      count=$((count + 1))
      sleep 30
    fi
  done

  if [[ $count -gt 20 ]]; then
    echo "Timed out waiting for volume: ${VOLUME_ID}" >&2
    exit 1
  fi

  echo "Volume is available: ${VOLUME_ID}"
}
