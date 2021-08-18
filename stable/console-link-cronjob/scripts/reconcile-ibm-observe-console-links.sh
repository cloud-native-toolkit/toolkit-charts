#!/bin/bash

if [[ -z "${DEFAULT_SECTION}" ]]; then
  DEFAULT_SECTION="Cloud-Native Toolkit"
fi

if [[ -z "${DEFAULT_LOCATION}" ]]; then
  DEFAULT_LOCATION="ApplicationMenu"
fi

NAMESPACE="ibm-observe"

# list all routes with console-link.cloud-native-toolkit.dev/enabled annotation
DAEMON_SETS=$(kubectl get daemonsets -n "${NAMESPACE}" -o yaml | yq eval -j '.' - | jq -c '.items[] | del(.metadata.annotations["kubectl.kubernetes.io/last-applied-configuration"])')

AGENT_NAME=$(echo "${DAEMON_SETS}" | jq -r 'select(.metadata.name == "logdna-agent") | .metadata.name // empty')
name="ibm-logging"
imageURL="${LOGGING_IMAGE}"
text="IBM Log Analysis"
type="logging"
url="https://cloud.ibm.com/observe/logging"

if [[ -n "${AGENT_NAME}" ]] && ! kubectl get consolelink "${name}" 1> /dev/null 2> /dev/null; then
  echo "Looking up guid for ${AGENT_NAME}"
  guid=$(kubectl get configmap -n "${NAMESPACE}" -o json | jq -r --arg NAME "${AGENT_NAME}" '.items | .[] | select(.data.daemonsetName == $NAME) | .metadata.name')
  if [[ -n "${guid}" ]]; then
    url="https://cloud.ibm.com/observe/embedded-view/${type}/${guid}"
  fi

  echo "Using url for ${AGENT_NAME}: ${url}"

  cat > /tmp/console-link.yaml << EOL
apiVersion: console.openshift.io/v1
kind: ConsoleLink
metadata:
  name: $name
spec:
  applicationMenu:
    imageURL: "$imageURL"
    section: "$DEFAULT_SECTION"
  href: "$url"
  location: "$DEFAULT_LOCATION"
  text: "$text"
EOL

  echo "Creating/updating consolelink: ${name}"
  kubectl apply -f /tmp/console-link.yaml
elif [[ -z "${AGENT_NAME}" ]]; then
  # delete consolelink
  kubectl delete consolelink "${name}"
else
  echo "Console link already exists: ${name}"
fi

AGENT_NAME=$(echo "${DAEMON_SETS}" | jq -r 'select(.metadata.name == "sysdig-agent") | .metadata.name // empty')
name="ibm-monitoring"
imageURL="${MONITORING_IMAGE}"
text="IBM Monitoring"
type="monitoring"
url="https://cloud.ibm.com/observe/monitoring"

if [[ -n "${AGENT_NAME}" ]] && ! kubectl get consolelink "${name}" 1> /dev/null 2> /dev/null; then
  echo "Looking up guid for ${AGENT_NAME}"
  guid=$(kubectl get configmap -n "${NAMESPACE}" -o json | jq -r --arg NAME "${AGENT_NAME}" '.items | .[] | select(.data.daemonsetName == $NAME) | .metadata.name')
  if [[ -n "${guid}" ]]; then
    url="https://cloud.ibm.com/observe/embedded-view/${type}/${guid}"
  fi

  echo "Using url for ${AGENT_NAME}: ${url}"

  cat > /tmp/console-link.yaml << EOL
apiVersion: console.openshift.io/v1
kind: ConsoleLink
metadata:
  name: $name
spec:
  applicationMenu:
    imageURL: "$imageURL"
    section: "$DEFAULT_SECTION"
  href: "$url"
  location: "$DEFAULT_LOCATION"
  text: "$text"
EOL

  echo "Creating/updating consolelink: ${name}"
  kubectl apply -f /tmp/console-link.yaml
elif [[ -z "${AGENT_NAME}" ]]; then
  # delete consolelink
  kubectl delete consolelink "${name}"
else
  echo "Console link already exists: ${name}"
fi
