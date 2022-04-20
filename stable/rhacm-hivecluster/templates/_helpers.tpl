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

{{- define "metadata.labels.cloud" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{ .Values.cloud.provider }}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    Amazon
  {{- end -}}
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
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "clusterdeployment.platform.aws" . -}}
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

{{- define "clusterdeployment.platform.aws" -}}
platform:
  aws:
    credentialsSecretRef:
      name: {{ include "cluster.name" . }}-aws-creds
    region: {{ include "cloud.region" . }}
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
    {{- include "cloud.worker.diskSizeGB.value" . | default "1024" -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cloud.worker.diskSizeGB.value" . | default "100" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.worker.diskSizeGB.value" -}}
  {{- if .Values.cloud -}}
    {{- if .Values.cloud.worker -}}
      {{- if .Values.cloud.worker.diskSizeGB -}}
        {{- .Values.cloud.worker.diskSizeGB -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.worker.vmsize" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cloud.worker.vmsize.value" . | default "Standard_D4s_v3" -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cloud.worker.vmsize.value" . | default "m5.xlarge" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.worker.vmsize.value" -}}
  {{- if .Values.cloud -}}
    {{- if .Values.cloud.worker -}}
      {{- if .Values.cloud.worker.vmSize -}}
        {{- .Values.cloud.worker.vmSize -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.worker.diskType" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cloud.worker.diskType.value" . | default "Premium_LRS" -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cloud.worker.diskType.value" . | default "io1" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.worker.diskType.value" -}}
  {{- if .Values.cloud -}}
    {{- if .Values.cloud.worker -}}
      {{- if .Values.cloud.worker.diskType -}}
        {{- .Values.cloud.worker.diskType -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.worker.diskIOPS" -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cloud.worker.diskType.value" . | default "2000" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.worker.diskIOPS.value" -}}
  {{- if .Values.cloud -}}
    {{- if .Values.cloud.worker -}}
      {{- if .Values.cloud.worker.diskIOPS -}}
        {{- .Values.cloud.worker.diskIOPS -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.master.diskIOPS" -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cloud.master.diskIOPS.value" . -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.master.diskIOPS.value" -}}
  {{- if .Values.cloud -}}
    {{- if .Values.cloud.master -}}
      {{- if .Values.cloud.master.diskIOPS -}}
        {{- .Values.cloud.master.diskIOPS -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.master.diskType" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cloud.master.diskType.value" . | default "Premium_LRS" -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cloud.master.diskType.value" . | default "io1" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.master.diskType.value" -}}
  {{- if .Values.cloud -}}
    {{- if .Values.cloud.master -}}
      {{- if .Values.cloud.master.diskType -}}
        {{- .Values.cloud.master.diskType -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.master.diskSizeGB" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cloud.master.diskSizeGB.value" . | default "1024" -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cloud.master.diskSizeGB.value" . | default "100" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.master.diskSizeGB.value" -}}
  {{- if .Values.cloud -}}
    {{- if .Values.cloud.master -}}
      {{- if .Values.cloud.master.diskSizeGB -}}
        {{- .Values.cloud.master.diskSizeGB -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.master.vmsize" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "cloud.master.vmsize.value" . | default "Standard_D4s_v3" -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cloud.master.vmsize.value" . | default "m5.xlarge" -}}
  {{- end -}}
{{- end -}}

{{- define "cloud.master.vmsize.value" -}}
  {{- if .Values.cloud -}}
    {{- if .Values.cloud.master -}}
      {{- if .Values.cloud.master.vmSize -}}
        {{- .Values.cloud.master.vmSize -}}
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
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "cluster.credentials.secret.aws" . -}}
  {{- end -}}
{{- end -}}

{{- define "cluster.credentials.secret.azure" -}}
data:
- secretKey: osServicePrincipal
  remoteRef:
    key: 595f66cd-047c-dbdf-9467-948d74346e1a
refreshInterval: 24h0m0s
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

{{- define "cluster.credentials.secret.aws" -}}
data:
  - secretKey: awsAccessKeyId
    remoteRef:
      key: 4d18cfd7-84ee-dbb5-7567-cfef62391453
  - secretKey: awsSecretAccessKey
    remoteRef:
      key: 8a79517a-04f6-b772-cda6-bde1071d9005
refreshInterval: 24h0m0s
secretStoreRef:
  name: cluster
  kind: ClusterSecretStore
target:
  name: {{ include "cluster.name" . }}-aws-creds
  creationPolicy: Owner
  template:
    type: Opaque
    data:
      aws_access_key_id: |- 
        {{ "{{ .awsAccessKeyId | toString }}" }}
      aws_secret_access_key: |- 
        {{ "{{ .awsSecretAccessKey | toString }}" }}
{{- end -}}

{{- define "gitops.instance.namespace" -}}
  {{- if .Values.gitops -}}
    {{- if .Values.gitops.instance -}}
      {{- if .Values.gitops.instance.namespace -}}
        {{ .Values.gitops.instance.namespace }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "gitops.channel.namespace" -}}
  {{- if .Values.gitops -}}
    {{- if .Values.gitops.channel -}}
      {{- if .Values.gitops.channel.namespace -}}
        {{ .Values.gitops.channel.namespace }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "gitops.channel.name" -}}
  {{- if .Values.gitops -}}
    {{- if .Values.gitops.channel -}}
      {{- if .Values.gitops.channel.name -}}
        {{ .Values.gitops.channel.name }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{- define "machinepool.platform" -}}
  {{- if eq .Values.cloud.provider "Azure" -}}
    {{- include "machinepool.platform.azure" . -}}
  {{- end -}}
  {{- if eq .Values.cloud.provider "AWS" -}}
    {{- include "machinepool.platform.aws" . -}}
  {{- end -}}
{{- end -}}

{{- define "machinepool.platform.azure" -}}
azure:
  osDisk:
    diskSizeGB: {{ include "cloud.worker.diskSizeGB" . }}
  type: {{ include "cloud.worker.vmsize" . }}
  zones:
    - "1"
    - "2"
    - "3"
{{- end -}}

{{- define "machinepool.platform.aws" -}}
aws:
  rootVolume:
    iops: {{ include "cloud.worker.diskIOPS" . | default "2000" }}
    size: {{ include "cloud.worker.diskSizeGB" . }}
    type: {{ include "cloud.worker.diskType" . | default "io1" }}
  type: {{ include "cloud.worker.vmsize" . }}
{{- end -}}

{{- define "cluster.sshkey" -}}
  {{- if .Values.cluster.publicsshkey -}}
    {{- .Values.cluster.publicsshkey -}}
  {{- end -}}
{{- end -}}