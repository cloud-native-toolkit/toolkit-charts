{{/*
Default MachineSet Replica Count
{{ $params := dict "Values" .Values "Name" .Name}}
*/}}

{{- define "machineset.defaultReplicaCount" -}}
{{- if eq $.Values.cloudProvider.name "aws" -}}
{{- if eq .Name "storage" -}}
{{- default "1" .Values.cloud.storageNodes.nodeCount }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "1" .Values.cloud.infraNodes.nodeCount }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "0" .Values.cloud.cloudpakNodes.nodeCount }}
{{- end -}}
{{- end }}
{{- if eq $.Values.cloudProvider.name "azure" -}}
{{- if eq .Name "storage" -}}
{{- default "1" .Values.cloud.storageNodes.nodeCount }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "1" .Values.cloud.infraNodes.nodeCount }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "0" .Values.cloud.cloudpakNodes.nodeCount }}
{{- end -}}
{{- end -}}
{{- if eq $.Values.cloudProvider.name "vsphere" -}}
{{- if eq .Name "storage" -}}
{{- default "3" .Values.vsphere.storageNodes.nodeCount }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "3" .Values.vsphere.infraNodes.nodeCount }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "0" .Values.vsphere.cloudpakNodes.nodeCount }}
{{- end -}}
{{- end -}}
{{- if eq $.Values.cloudProvider.name "ibmcloud" -}}
{{- if eq .Name "storage" -}}
{{- default "1" .Values.cloud.storageNodes.nodeCount }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "1" .Values.cloud.infraNodes.nodeCount }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "0" .Values.cloud.cloudpakNodes.nodeCount }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Default Node Sizes
{{ $params := dict "Values" .Values "Name" .Name}}
*/}}

{{- define "machineset.defaultNodeSize" -}}
{{- if eq $.Values.cloudProvider.name "aws" -}}
{{- if eq .Name "storage" -}}
{{- default "m5.4xlarge" .Values.cloud.storageNodes.instanceType }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "m5.xlarge" .Values.cloud.infraNodes.instanceType }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "m5.2xlarge" .Values.cloud.cloudpakNodes.instanceType }}
{{- end -}}
{{- end }}
{{- if eq $.Values.cloudProvider.name "azure" -}}
{{- if eq .Name "storage" -}}
{{- default "Standard_D16s_v3" .Values.cloud.storageNodes.instanceType }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "Standard_D4s_v3" .Values.cloud.infraNodes.instanceType }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "Standard_D8s_v3" .Values.cloud.cloudpakNodes.instanceType }}
{{- end -}}
{{- end -}}
{{- if eq $.Values.cloudProvider.name "ibmcloud" -}}
{{- if eq .Name "storage" -}}
{{- default "bx2d-16x64" .Values.cloud.storageNodes.instanceType }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "bx2d-4x16" .Values.cloud.infraNodes.instanceType }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "bx2d-8x32" .Values.cloud.cloudpakNodes.instanceType }}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Default Node Volume Type
{{ $params := dict "Values" .Values "Name" .Name}}
*/}}

{{- define "machineset.defaultNodeVolumeType" -}}
{{- if eq $.Values.cloudProvider.name "aws" -}}
{{- if eq .Name "storage" -}}
{{- default "gp2" .Values.cloud.storageNodes.volumeType }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "gp2" .Values.cloud.infraNodes.volumeType }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "gp2" .Values.cloud.cloudpakNodes.volumeType }}
{{- end -}}
{{- end }}
{{- if eq $.Values.cloudProvider.name "azure" -}}
{{- if eq .Name "storage" -}}
{{- default "Premium_LRS" .Values.cloud.storageNodes.volumeType }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "Premium_LRS" .Values.cloud.infraNodes.volumeType }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "Premium_LRS" .Values.cloud.cloudpakNodes.volumeType }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Default Node Volume Size
{{ $params := dict "Values" .Values "Name" .Name}}
*/}}

{{- define "machineset.defaultNodeVolumeSize" -}}
{{- if eq $.Values.cloudProvider.name "aws" -}}
{{- if eq .Name "storage" -}}
{{- default "128" .Values.cloud.storageNodes.volumeSize }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "128" .Values.cloud.infraNodes.volumeSize }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "128" .Values.cloud.cloudpakNodes.volumeSize }}
{{- end -}}
{{- end }}
{{- if eq $.Values.cloudProvider.name "azure" -}}
{{- if eq .Name "storage" -}}
{{- default "128" .Values.cloud.storageNodes.volumeSize }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "128" .Values.cloud.infraNodes.volumeSize }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "128" .Values.cloud.cloudpakNodes.volumeSize }}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
MachineSet AWS Check Image
{{ $params := dict "Values" .Values }}
*/}}

{{- define "machineset.aws.image" -}}
{{- $image := required "You need to provide the cloud.image of your AWS cluster in your values.yaml file" $.Values.cloud.image -}}
{{ $.Values.cloud.image }}
{{- end -}}

{{- define "machineset.vsphere.defaultNodeCPU" -}}
{{- if eq .Name "storage" -}}
{{- default "16" $.Values.vsphere.storageNodes.numCPUs }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "4" $.Values.vsphere.infraNodes.numCPUs }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "8" $.Values.vsphere.cloudpakNodes.numCPUs }}
{{- end -}}
{{- end -}}

{{- define "machineset.vsphere.NodeCoresPerSocket" -}}
{{- if eq .Name "storage" -}}
{{- default "1" $.Values.vsphere.storageNodes.numCoresPerSocket }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "1" $.Values.vsphere.infraNodes.numCoresPerSocket }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "1" $.Values.vsphere.cloudpakNodes.numCoresPerSocket }}
{{- end -}}
{{- end -}}

{{- define "machineset.vsphere.defaultNodeMemory" -}}
{{- if eq .Name "storage" -}}
{{- default "65536" $.Values.vsphere.storageNodes.memoryMiB }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "16384" $.Values.vsphere.infraNodes.memoryMiB }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "32768" $.Values.vsphere.cloudpakNodes.memoryMiB }}
{{- end -}}
{{- end -}}

{{- define "machineset.vsphere.defaultNodeDiskSize" -}}
{{- if eq .Name "storage" -}}
{{- default "120" $.Values.vsphere.storageNodes.diskGiB }}
{{- end -}}
{{- if eq .Name "infra" -}}
{{- default "120" $.Values.vsphere.infraNodes.diskGiB }}
{{- end -}}
{{- if eq .Name "cp4x" -}}
{{- default "120" $.Values.vsphere.cloudpakNodes.diskGiB }}
{{- end -}}
{{- end -}}


{{- define "machineset.azure.resourceGroup" -}}
{{- $resourceGroup := printf "%s-rg" $.Values.infrastructureId -}}
{{ default $resourceGroup $.Values.cloud.resourceGroup }}
{{- end -}}

{{- define "machineset.azure.networkResourceGroup" -}}
{{- $networkResourceGroup := printf "%s-rg" $.Values.infrastructureId -}}
{{ default $networkResourceGroup $.Values.cloud.networkResourceGroup }}
{{- end -}}

{{- define "machineset.azure.workerSubnet" -}}
{{- $workerSubnet := printf "%s-worker-subnet" $.Values.infrastructureId -}}
{{ default $workerSubnet $.Values.cloud.workerSubnet }}
{{- end -}}

{{- define "machineset.azure.virtualNetwork" -}}
{{- $virtualNetwork := printf "%s-vnet" $.Values.infrastructureId -}}
{{ default $virtualNetwork $.Values.cloud.virtualNetwork }}
{{- end -}}

