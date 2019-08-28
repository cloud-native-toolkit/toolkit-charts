{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tool-config.name" -}}
{{- required "The 'name' is required!" .Values.name -}}
{{- end -}}

{{- define "tool-config.config-name" -}}
{{- printf "%s-%s" (include "tool-config.name" .) "config" -}}
{{- end -}}

{{- define "tool-config.secret-name" -}}
{{- printf "%s-%s" (include "tool-config.name" .) "access" -}}
{{- end -}}

{{/*

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tool-config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tool-config.NAME" -}}
{{- $name := include "tool-config.name" . -}}
{{- $name | upper | replace "-" "_" -}}
{{- end -}}
