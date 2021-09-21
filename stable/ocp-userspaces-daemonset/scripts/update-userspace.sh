#!/usr/bin/env bash

if [[ -z "${NODE_NAME}" ]]; then
  echo "NODE_NAME environment variable not set"
  exit 1
fi

set -m
set -x

chroot /host
echo "user.max_user_namespaces = 31477" > /etc/sysctl.d/99-usernamespaces.conf
sysctl --system
cat /proc/sys/user/max_user_namespaces

while true; do
  sleep 60
done
