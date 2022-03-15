{{- define "cluster.installconfig.controlPlane.platform" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cluster.installconfig.controlPlane.platform.azure" . -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.installconfig.controlPlane.platform.azure" -}}
azure:
  osDisk:
    diskSizeGB: {{ include "cloud.master.diskSizeGB" . }}
  type:  {{ include "cloud.master.vmsize" . }}
  zones:
  - "1"
  - "2"
  - "3"
{{- end -}}

{{- define "cluster.installconfig.compute.platform" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cluster.installconfig.compute.platform.azure" . -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.installconfig.compute.platform.azure" -}}
azure:
  osDisk:
    diskSizeGB: {{ include "cloud.worker.diskSizeGB" . }}
  type:  {{ include "cloud.worker.vmsize" . }}
  zones:
  - "1"
  - "2"
  - "3"
{{- end -}}

{{- define "cluster.installconfig.platform" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cluster.installconfig.platform.azure" . -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.installconfig.platform.azure" -}}
azure:
  baseDomainResourceGroupName: {{ include "cloud.azure.baseDomainResourceGroupName" . }}
  cloudName: AzurePublicCloud
  region: {{ include "cloud.region" . }}
  outboundType: {{ .Values.cloud.azure.outboundType | default "Loadbalancer" }}
  {{- if .Values.cloud.azure.resourceGroupName }}
  resourceGroupName: {{ .Values.cloud.azure.resourceGroupName }}
  {{- end -}}
  {{ if .Values.cloud.azure.virtualNetwork }}
  virtualNetwork: {{ .Values.cloud.azure.virtualNetwork }}
  {{- end -}}
  {{ if .Values.cloud.azure.computeSubnet }}
  computeSubnet: {{ .Values.cloud.azure.computeSubnet }}
  {{- end -}}
  {{ if .Values.cloud.azure.controlPlaneSubnet }}
  controlPlaneSubnet: {{ .Values.cloud.azure.controlPlaneSubnet }}
  {{- end -}}
  {{ if .Values.cloud.azure.networkResourceGroupName }}
  networkResourceGroupName: {{ .Values.cloud.azure.networkResourceGroupName }}
  {{- end -}}
{{- end -}}


{{- define "cluster.installconfig" -}}
apiVersion: v1
metadata:
  name: {{ include "cluster.name" . }}
baseDomain: {{ include "cluster.basedomain" .}}
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
  platform:
    {{- include "cluster.installconfig.controlPlane.platform" . | nindent 4}}
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 3
  platform:
    {{- include "cluster.installconfig.compute.platform" . | nindent 4}}
networking:
  networkType: {{ include "cluster.networking.networkType" . | default "OpenShiftSDN" }}
  clusterNetwork:
  - cidr: {{ include "cluster.networking.clusterNetwork.cidr" . | default "10.128.0.0/14" }}
    hostPrefix: {{ include "cluster.networking.clusterNetwork.hostPrefix" . | default "23" }}
  machineNetwork:
  - cidr: {{ include "cluster.networking.machineNetwork.cidr" . | default "10.0.0.0/16"}}
  serviceNetwork:
  - {{ include "cluster.networking.serviceNetwork.cidr" . | default "172.30.0.0/16" }}
platform:
  {{- include "cluster.installconfig.platform" . | nindent 2}}
pullSecret: "" # skip, hive will inject based on it's secrets
sshKey: |-
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJlPS4hSmr8DKh3L9YVOusuA3w8aqQc+33Z15ylXpEg30K6xkBZ40zTtAGACsBvsGAWuVuCeOEtnfU9d9MCTYU0FgnT9u+5hUrcAxBhEjFpDmhaexqHFWrYalFFgvIdTttFBLYIIb2nHQ9t7YdlmQIJuSRTCANs4lMmqyrCHCgcO+GXmubvg2lFfDKZjMyY7hn+FCeWKyBPxmL7AbyAp0Q9asL8zJhSVpKtjWQS5tOeV0RrwgrKb72qfLcq6yJB+d2ihmTvnLzikFeBQpwTXSktj/2J2vudT82Eey4u9QPAr6v24drdG+viM2KGpRRQefvmGASkH0vcaMnfhrhpnwf ncolon@ncm-mbpr.local
{{- end -}}