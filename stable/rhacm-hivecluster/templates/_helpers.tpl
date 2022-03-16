{{- define "cluster.namespace" -}}
  {{- default .Values.cluster.name .Values.cluster.namespace -}}
{{- end -}}

{{- define "cluster.vendor" -}}
  {{- .Values.cluster.vendor | default "OpenShift" -}}
{{- end -}}

{{- define "cluster.name" -}}
  {{- .Values.cluster.name -}}
{{- end -}}

{{- define "cloud.provider" -}}
  {{ .Values.cloud.provider }}
{{- end -}}

{{- define "cluster.basedomain" -}}
  {{ .Values.cluster.baseDomain }}
{{- end -}}

{{- define "cloud.region" -}}
  {{ .Values.cloud.region }}
{{- end -}}

{{- define "clusterdeployment.platform" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "clusterdeployment.platform.azure" . -}}
  {{- end -}}
{{- end -}}


{{- define "clusterdeployment.platform.azure" -}}
platform:
  azure:
    baseDomainResourceGroupName: {{ include "cloud.azure.baseDomainResourceGroupName" . }}
    credentialsSecretRef:
      name: {{ include "cluster.name" . }}-azure-creds
    region: {{ include "cloud.region" . }}
    cloudName: AzurePublicCloud
{{- end -}}

{{- define "cloud.azure.baseDomainResourceGroupName" -}}
  {{- if .Values.cloud.azure.baseDomainResourceGroupName -}}
    {{- .Values.cloud.azure.baseDomainResourceGroupName -}}
  {{- end -}}
{{- end -}}

{{- define "imageset.name" -}}
  img{{ .Values.cluster.version }}-x86-64-appsub
{{- end -}}

{{- define "cloud.worker.diskSizeGB" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cloud.azure.worker.diskSizeGB" . | default "1024" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.azure.worker.diskSizeGB" -}}
  {{- if .Values.cloud.azure -}}
    {{- if .Values.cloud.azure.worker -}}
      {{- if .Values.cloud.azure.worker.diskSizeGB -}}
        {{- .Values.cloud.azure.worker.diskSizeGB -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.worker.vmsize" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cloud.azure.worker.vmsize" . | default "Standard_D2s_v3" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.azure.worker.vmsize" -}}
  {{- if .Values.cloud.azure -}}
    {{- if .Values.cloud.azure.worker -}}
      {{- if .Values.cloud.azure.worker.vmSize -}}
        {{- .Values.cloud.azure.worker.vmSize -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}


{{- define "cloud.master.diskSizeGB" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cloud.azure.master.diskSizeGB" . | default "1024" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.azure.master.diskSizeGB" -}}
  {{- if .Values.cloud.azure -}}
    {{- if .Values.cloud.azure.master -}}
      {{- if .Values.cloud.azure.master.diskSizeGB -}}
        {{- .Values.cloud.azure.master.diskSizeGB -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.master.vmsize" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cloud.azure.master.vmsize" . | default "Standard_D4s_v3" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.azure.master.vmsize" -}}
  {{- if .Values.cloud.azure -}}
    {{- if .Values.cloud.azure.master -}}
      {{- if .Values.cloud.azure.master.vmSize -}}
        {{- .Values.cloud.azure.master.vmSize -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}


{{- define "cluster.networking.networkType" -}}
  {{- if .Values.cluster.networking -}}
    {{- if .Values.cluster.networking.networkType -}}
      {{- .Values.cluster.networking.networkType -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.networking.clusterNetwork.cidr" -}}
  {{- if .Values.cluster.networking -}}
    {{- if .Values.cluster.networking.clusterNetwork -}}
      {{- if .Values.cluster.networking.clusterNetwork.cidr -}}
        {{- .Values.cluster.networking.clusterNetwork.cidr -}}
      {{- end -}}        
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.networking.clusterNetwork.hostPrefix" -}}
  {{- if .Values.cluster.networking -}}
    {{- if .Values.cluster.networking.clusterNetwork -}}
      {{- if .Values.cluster.networking.clusterNetwork.hostPrefix -}}
        {{- .Values.cluster.networking.clusterNetwork.hostPrefix -}}
      {{- end -}}        
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.networking.machineNetwork.cidr" -}}
  {{- if .Values.cluster.networking -}}
    {{- if .Values.cluster.networking.machineNetwork -}}
      {{- if .Values.cluster.networking.machineNetwork.cidr -}}
        {{- .Values.cluster.networking.machineNetwork.cidr -}}
      {{- end -}}        
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.networking.serviceNetwork.cidr" -}}
  {{- if .Values.cluster.networking -}}
    {{- if .Values.cluster.networking.serviceNetwork -}}
      {{- if .Values.cluster.networking.serviceNetwork.cidr -}}
        {{- .Values.cluster.networking.serviceNetwork.cidr -}}
      {{- end -}}        
    {{- end -}}
  {{- end -}}
{{- end -}}

{{ define "cluster.credentials.secret" }}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cluster.credentials.secret.azure" . -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.credentials.secret.azure" -}}
data:
- secretKey: osServicePrincipal
  remoteRef:
    key: 595f66cd-047c-dbdf-9467-948d74346e1a
refreshInterval: 1m
secretStoreRef:
  name: cluster
  kind: ClusterSecretStore
target:
  name: {{ include "cluster.name" . }}-azure-creds
  creationPolicy: Owner
  template:
    type: Opaque
    data:
      osServicePrincipal.json: |-
        {{ "{{ .osServicePrincipal | toString }}" }}
{{- end -}}
