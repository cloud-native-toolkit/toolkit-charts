{{/*
Expand the name of the chart.
*/}}
{{- define "ocp-oauth-github.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ocp-oauth-github.fullname" -}}
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
{{- define "ocp-oauth-github.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ocp-oauth-github.labels" -}}
helm.sh/chart: {{ include "ocp-oauth-github.chart" . }}
{{ include "ocp-oauth-github.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ocp-oauth-github.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ocp-oauth-github.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ocp-oauth-github.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ocp-oauth-github.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "ocp-oauth-github.imageTag" -}}
{{ default .Chart.AppVersion .Values.imageTag }}
{{- end }}

{{- define "ocp-oauth-github.namespace" -}}
{{- if ne .Release.Namespace "openshift-config" -}}
{{ required "This chart can only be installed in the openshift-config namespace. Use the -n flag to provide the namespace." "" }}
{{- else -}}
{{ .Release.Namespace }}
{{- end -}}
{{- end -}}
