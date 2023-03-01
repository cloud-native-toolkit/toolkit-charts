{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "watsonnlp.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "watsonnlp.fullname" -}}
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
Common labels
*/}}
{{- define "watsonnlp.labels" -}}
  {{- $params := . -}}
  {{- $root := index $params 0 -}}
  {{- $compName := index $params 1 -}}
helm.sh/chart: {{ include "watsonnlp.chart" $root }}
{{ include "watsonnlp.selectorLabels" (list $root $compName) }}
{{- if $root.Chart.AppVersion }}
app.kubernetes.io/version: {{ $root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $root.Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "watsonnlp.selectorLabels" -}}
  {{- $params := . -}}
  {{- $root := index $params 0 -}}
  {{- $compName := index $params 1 -}}
app.kubernetes.io/name: {{ include "watsonnlp.fullname" $root }}
app.kubernetes.io/component: {{ $compName }}
app.kubernetes.io/instance: {{ $root.Release.Name }}
{{- end }}

{{/*
Registry lookup
*/}}
{{- define "watsonnlp.registries" }}
  {{- $root := index . 0 }}
  {{- $registryName := index . 1 }}
  {{- $image := index . 2 }}
  {{- $matchFlag := "false" }}
  {{- range $k, $v := $root.Values.registries }}
    {{- if eq $v.name $registryName}}
      {{- if eq $matchFlag "false" }}
        {{ print $v.url}}/{{print $image}}
        {{- $matchFlag = "true" }}
      {{- end }}  
    {{- end }}
  {{- end }}
{{- end }}