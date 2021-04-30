{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ocp-console-notification.name" -}}
{{- (default .Release.Name .Values.name) | nospace | lower -}}
{{- end -}}

{{- define "ocp-console-notification.location" -}}
{{- default "BannerTop" .Values.location -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "ocp-console-notification.labels" -}}
helm.sh/chart: {{ include "ocp-console-notification.chart" . }}
{{ include "ocp-console-notification.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ocp-console-notification.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ocp-console-notification.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ocp-console-notification.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ocp-console-notification.NAME" -}}
{{- include "ocp-console-notification.name" . | upper | replace "-" "_" -}}
{{- end -}}

{{- define "ocp-console-notification.app" -}}
{{- if .Values.app -}}
{{ .Values.app | quote }}
{{- else -}}
{{- include "ocp-console-notification.name" . -}}
{{- end -}}
{{- end -}}
