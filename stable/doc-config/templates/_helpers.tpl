{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "doc-config.name" -}}
{{- (default .Release.Name .Values.name) | nospace | lower -}}
{{- end -}}

{{- define "doc-config.display-name" -}}
{{- default .Release.Name (default .Values.name .Values.displayName) -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "doc-config.labels" -}}
helm.sh/chart: {{ include "doc-config.chart" . }}
app: {{ include "doc-config.app" . }}
release: {{ .Release.Name | quote }}
app.kubernetes.io/part-of: {{ include "doc-config.app" . }}
app.kubernetes.io/component: {{ .Values.component | quote }}
group: {{ .Values.group | quote }}
grouping: {{ .Values.grouping | quote }}
{{ include "doc-config.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "doc-config.selectorLabels" -}}
app.kubernetes.io/name: {{ include "doc-config.app" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "doc-config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "doc-config.NAME" -}}
{{- include "doc-config.name" . | upper | replace "-" "_" -}}
{{- end -}}

{{- define "doc-config.app" -}}
{{- if .Values.app -}}
{{ .Values.app | quote }}
{{- else -}}
{{- include "doc-config.name" . -}}
{{- end -}}
{{- end -}}
