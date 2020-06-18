{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tool-config.name" -}}
{{- (default .Release.Name .Values.name) | nospace | lower -}}
{{- end -}}

{{- define "tool-config.display-name" -}}
{{- default .Release.Name (default .Values.name .Values.displayName) -}}
{{- end -}}

{{- define "tool-config.config-name" -}}
{{- printf "%s-%s" (include "tool-config.name" .) "config" -}}
{{- end -}}

{{- define "tool-config.secret-name" -}}
{{- printf "%s-%s" (include "tool-config.name" .) "access" -}}
{{- end -}}

{{- define "tool-config.ingressSubdomain" -}}
{{ default .Values.global.ingressSubdomain .Values.ingressSubdomain -}}
{{- end -}}

{{- define "tool-config.url" -}}
{{- if .Values.url -}}
{{ .Values.url }}
{{- else -}}
{{- if .Values.includeNamespace -}}
{{ printf "https://%s-%s.%s" .Values.host .Release.Namespace (include "tool-config.ingressSubdomain" .)}}
{{- else -}}
{{ printf "https://%s.%s" .Values.host (include "tool-config.ingressSubdomain" .) }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tool-config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tool-config.NAME" -}}
{{- include "tool-config.name" . | upper | replace "-" "_" -}}
{{- end -}}

{{- define "tool-config.app" -}}
{{- if .Values.app -}}
{{ .Values.app | quote }}
{{- else -}}
{{- include "tool-config.name" . -}}
{{- end -}}
{{- end -}}
