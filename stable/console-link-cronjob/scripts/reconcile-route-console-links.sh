#!/bin/bash

if [[ -z "${DEFAULT_SECTION}" ]]; then
  DEFAULT_SECTION="Cloud-Native Toolkit"
fi

if [[ -z "${DEFAULT_LOCATION}" ]]; then
  DEFAULT_LOCATION="ApplicationMenu"
fi

# list all routes and configmaps with console-link.cloud-native-toolkit.dev/enabled label
RESOURCES=$(kubectl get routes,configmaps -A -l console-link.cloud-native-toolkit.dev/enabled=true -o yaml | yq eval -j '.' - | jq -c '.items[] | del(.metadata.annotations["kubectl.kubernetes.io/last-applied-configuration"])')

if [[ -z "${RESOURCES}" ]]; then
  echo "No resources found with 'console-link.cloud-native-toolkit.dev/enabled=true' label"
  exit 0
fi

# for each resource create/update a console link
echo "${RESOURCES}" | while read -r resource; do
  namespace="$(echo "${resource}" | jq -r '.metadata.namespace')"
  name="$(echo "${resource}" | jq -r '.metadata.name')"
  if [[ -z "${name}" ]]; then
    echo "Error parsing resource: ${resource}"
    continue
  fi

  kind="$(echo "${resource}" | jq -r '.kind')"

  if [[ "${kind}" == "Route" ]]; then
    host="$(echo "${resource}" | jq -r '.spec.host')"
    url="https://${host}"
  elif [[ "${kind}" == "ConfigMap" ]]; then
    url="$(echo "${resource}" | jq -r '.data.url')"
  else
    echo "Unhandled resource: ${kind}"
    continue
  fi

  category="$(echo "${resource}" | jq -r '.metadata.annotations["console-link.cloud-native-toolkit.dev/category"] // empty')"
  section="$(echo "${resource}" | jq -r --arg DEFAULT "${DEFAULT_SECTION}" '.metadata.annotations["console-link.cloud-native-toolkit.dev/section"] // $DEFAULT')"
  location="$(echo "${resource}" | jq -r --arg DEFAULT "${DEFAULT_LOCATION}" '.metadata.annotations["console-link.cloud-native-toolkit.dev/location"] // $DEFAULT')"
  imageURL="$(echo "${resource}" | jq -r '.metadata.annotations["console-link.cloud-native-toolkit.dev/imageUrl"] // empty')"
  text="$(echo "${resource}" | jq -r --arg DEFAULT "$name" '.metadata.annotations["console-link.cloud-native-toolkit.dev/displayName"] // $DEFAULT')"

  app="$(echo "${resource}" | jq -r --arg DEFAULT "${name}" '.metadata.labels["app.kubernetes.io/name"] // $DEFAULT')"
  if [[ -z "${app}" ]]; then
    app="$(echo "${resource}" | jq -r --arg DEFAULT "${name}" '.metadata.labels["app"] // $DEFAULT')"
  fi
  partOf="$(echo "${resource}" | jq -r --arg DEFAULT "${name}" '.metadata.labels["app.kubernetes.io/part-of"] // $DEFAULT')"

  cat > /tmp/console-link.yaml << EOL
apiVersion: console.openshift.io/v1
kind: ConsoleLink
metadata:
  name: $name
spec:
  applicationMenu:
    imageURL: "$imageURL"
    section: "$section"
  href: "$url"
  location: "$location"
  text: "$text"
EOL

  echo "Creating/updating consolelink: ${name}"
  kubectl apply -f /tmp/console-link.yaml

  if [[ "${kind}" == "ConfigMap" ]]; then
    echo "ConfigMap already exists. Skipping config map create"
    continue
  fi

  prefix=$(echo ${name^^} | sed "s/-/_/g")

  cat > /tmp/configmap.yaml << EOL
apiVersion: v1
kind: ConfigMap
metadata:
  name: ${name}-config
  labels:
    group: cloud-native-toolkit
    app.kubernetes.io/component: tools
    app.kubernetes.io/part-of: ${partOf}
    app: ${app}
    app.kubernetes.io/name: ${app}
  annotations:
    console-link.cloud-native-toolkit.dev/category: ${category}
    console-link.cloud-native-toolkit.dev/section: ${section}
    console-link.cloud-native-toolkit.dev/location: ${location}
    console-link.cloud-native-toolkit.dev/imageUrl: ${imageUrl}
    console-link.cloud-native-toolkit.dev/displayName: ${text}
spec:
  ${prefix}_URL: "$url"
  url: "$url"
EOL

  echo "Creating/updating configmap: ${name}-config"
  kubectl apply -n "${namespace}" -f /tmp/configmap.yaml
done
