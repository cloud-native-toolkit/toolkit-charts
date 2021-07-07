{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "argocd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "argocd.destinations" -}}
{{- if . -}}
{{- range . }}
{{- if .targetNamespace -}}
- namespace: {{ .targetNamespace | quote }}
  server: {{ default "https://kubernetes.default.svc" .server | quote }}
{{- end -}}
{{- end -}}
{{- else -}}
{{- "" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "argocd.fullname" -}}
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
{{- define "argocd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "argocd.labels" -}}
helm.sh/chart: {{ include "argocd.chart" . }}
{{ include "argocd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "argocd.selectorLabels" -}}
app: argocd
app.kubernetes.io/name: {{ include "argocd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "argocd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "argocd.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "argocd.valueFiles" -}}
{{- if . -}}
{{ toYaml . }}
{{- else -}}
- values.yaml
{{- end -}}
{{- end -}}

{{- define "argocd.repoUrl" -}}
{{ default .Values.global.repoUrl .Values.repoUrl }}
{{- end -}}
