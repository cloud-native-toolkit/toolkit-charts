{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "tool-test.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tool-test.fullname" -}}
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
{{- define "tool-test.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create service name.
*/}}
{{- define "tool-test.service-name" -}}
{{- $fullName := include "tool-test.fullname" . -}}
{{- printf "%s-%s" .Values.service.name $fullName | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "tool-test.ingressSubdomain" -}}
{{- default .Values.global.ingressSubdomain .Values.ingress.subdomain -}}
{{- end -}}

{{- define "tool-test.ingress-host" -}}
{{- $ingressSubdomain := include "tool-test.ingressSubdomain" . -}}
{{- if .Values.ingress.includeNamespace -}}
{{- printf "%s-%s.%s" .Values.host .Release.Namespace $ingressSubdomain -}}
{{- else -}}
{{- printf "%s.%s" .Values.host $ingressSubdomain -}}
{{- end -}}
{{- end -}}

{{- define "tool-test.route-termination" -}}
{{- if .Values.sso.enabled -}}
{{ printf "reencrypt" }}
{{- else -}}
{{ printf "edge" }}
{{- end -}}
{{- end -}}

{{- define "tool-test.clusterType" -}}
{{ $clusterType := default .Values.global.clusterType .Values.clusterType }}
{{- if or (eq $clusterType "openshift") (regexFind "^ocp.*" $clusterType) -}}
{{- "openshift" -}}
{{- else -}}
{{- "kubernetes" -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "tool-test.labels" -}}
helm.sh/chart: {{ include "tool-test.chart" . }}
{{ include "tool-test.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tool-test.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tool-test.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
