{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ibmcloud.name" -}}
{{- default "cloud" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ibmcloud.config-name" -}}
{{- printf "%s-%s" (include "ibmcloud.name" .) "config" -}}
{{- end -}}

{{- define "ibmcloud.apikey-name" -}}
{{- printf "%s-%s" (include "ibmcloud.name" .) "access" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ibmcloud.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ibmcloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ibmcloud.registry_namespace" -}}
{{ .Values.registry_namespace | default .Values.resource_group | quote }}
{{- end -}}

{{- define "ibmcloud.cluster_name" -}}
{{- if .Values.cluster_name -}}
{{- .Values.cluster_name | quote -}}
{{- else -}}
{{- printf "%s-%s" .Values.resource_group "cluster" | quote -}}
{{- end -}}
{{- end -}}

{{- define "ibmcloud.tls_secret_name" -}}
{{- if .Values.tls_secret_name -}}
{{- .Values.tls_secret_name | quote -}}
{{- else -}}
{{- include "ibmcloud.cluster_name" . -}}
{{- end -}}
{{- end -}}

{{- define "ibmcloud.cluster_type" -}}
{{- if eq .Values.cluster_type "openshift" -}}
{{ .Values.cluster_type | quote }}
{{- else if eq .Values.cluster_type "kubernetes" -}}
{{ .Values.cluster_type | quote }}
{{- else -}}
{{ fail "The 'cluster_type' must either be 'openshift' or 'kubernetes'" }}
{{- end -}}
{{- end -}}

{{- define "ibmcloud.registry_password" -}}
{{- if .Values.registry_password -}}
{{ .Values.registry_password | quote }}
{{- else -}}
{{ .Values.apikey | quote }}
{{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "ibmcloud.labels" -}}
helm.sh/chart: {{ include "ibmcloud.chart" . }}
app: {{ include "ibmcloud.name" . }}
release: {{ .Release.Name | quote }}
app.kubernetes.io/part-of: {{ include "ibmcloud.name" . }}
app.kubernetes.io/component: {{ default "cloud" .Values.component | quote }}
group: {{ .Values.group | quote }}
grouping: {{ .Values.grouping | quote }}
{{ include "ibmcloud.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "ibmcloud.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ibmcloud.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}
