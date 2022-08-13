#!/usr/bin/env bash

if [[ -z "${SECRET_NAME}" ]]; then
  echo "SECRET_NAME environment variable must be set" >&2
  exit 1
fi

if [[ -z "${USERS}" ]]; then
  echo "USERS environment variable must be set" >&2
  exit 1
fi

if [[ -z "${PASSWORD}" ]]; then
  PASSWORD="password"
fi

if oc get secret "${SECRET_NAME}" 1> /dev/null 2> /dev/null; then
  echo "Extracting htpasswd file from secret"
  oc extract "secret/${SECRET_NAME}" --to=/tmp
fi

echo "${USERS}" | jq -c '.[]' | while read user; do

  username=$(echo "${user}" | jq -r ".name")
  password=$(echo "${user}" | jq -r --arg DEFAULT "${PASSWORD}" '.password // $DEFAULT')

  echo "Creating user: ${username}"

  if [[ ! -f /tmp/htpasswd ]]; then
    htpasswd -c -B -b /tmp/htpasswd "${username}" "${password}"
  else
    htpasswd -B -b /tmp/htpasswd "${username}" "${password}"
  fi
done

oc create secret generic "${SECRET_NAME}" --from-file=htpasswd=/tmp/htpasswd --dry-run=client --output json |
  oc apply -f -
