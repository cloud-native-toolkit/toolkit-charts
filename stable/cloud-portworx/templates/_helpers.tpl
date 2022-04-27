{{/*
Expand the name of the chart.
*/}}
{{- define "cloud-portworx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloud-portworx.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cloud-portworx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cloud-portworx.labels" -}}
helm.sh/chart: {{ include "cloud-portworx.chart" . }}
{{ include "cloud-portworx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cloud-portworx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloud-portworx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "cloud-portworx.essentials" }}
{{- eq .Values.class "essentials" }}
{{- end }}

{{- define "cloud-portworx.enterprise" }}
{{- eq .Values.class "enterprise" }}
{{- end }}

{{- define "cloud-portworx.deviceSpec" }}
{{- if and .type .size }}
{{- printf "type=%s,size=%s" .type .size }}
{{- else }}
{{- "" }}
{{- end }}
{{- end }}

{{- define "cloud-portworx.namespace" }}
{{- if eq .Release.Namespace "kube-system" }}
{{- .Release.Namespace }}
{{- else }}
{{- required "Portworx must be installed in kube-system namespace" "" }}
{{- end }}
{{- end }}
