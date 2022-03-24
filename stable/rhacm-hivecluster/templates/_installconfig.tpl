{{- define "cluster.installconfig.controlPlane.platform" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cluster.installconfig.controlPlane.platform.azure" . -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cluster.installconfig.controlPlane.platform.aws" . -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.installconfig.controlPlane.platform.azure" -}}
azure:
  osDisk:
    diskSizeGB: {{ include "cloud.master.diskSizeGB" . }}
    diskType:  {{ include "cloud.master.diskType" . }}
  type:  {{ include "cloud.master.vmsize" . }}
  zones:
  - "1"
  - "2"
  - "3"
{{- end -}}

{{- define "cluster.installconfig.controlPlane.platform.aws" -}}
aws:
  rootVolume:
    iops: {{ include "cloud.master.diskIOPS" . | default "4000" }}
    size: {{ include "cloud.master.diskSizeGB" . | default "100" }}
    type: {{ include "cloud.master.diskType" . | default "io1" }}
  type: {{ include "cloud.master.vmsize" . }}
{{- end -}}

{{- define "cluster.installconfig.compute.platform" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cluster.installconfig.compute.platform.azure" . -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cluster.installconfig.compute.platform.aws" . -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.installconfig.compute.platform.azure" -}}
azure:
  osDisk:
    diskSizeGB: {{ include "cloud.worker.diskSizeGB" . }}
    diskType: {{ include "cloud.worker.diskType" . }}
  type: {{ include "cloud.worker.vmsize" . }}
  zones:
  - "1"
  - "2"
  - "3"
{{- end -}}

{{- define "cluster.installconfig.compute.platform.aws" -}}
aws:
  rootVolume:
    iops: {{ include "cloud.worker.diskIOPS" . }}
    size: {{ include "cloud.worker.diskSizeGB" . }}
    type: {{ include "cloud.worker.diskType" . }}
  type: {{ include "cloud.worker.vmsize" . }}
{{- end -}}

{{- define "cluster.installconfig.platform" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cluster.installconfig.platform.azure" . -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cluster.installconfig.platform.aws" . -}}
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

{{- define "cluster.installconfig.platform.aws" -}}
aws:
  region: {{ include "cloud.region" . }}
  {{- if .Values.cloud.subnets }}
  subnets:
{{ toYaml .Values.cloud.subnets | indent 4}}
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
    {{- include "cluster.installconfig.compute.platform" . | nindent 4 }}
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
  {{ include "cluster.sshkey" . }}
{{- end -}}