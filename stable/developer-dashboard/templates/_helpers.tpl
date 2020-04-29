{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "developer-dashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "developer-dashboard.fullname" -}}
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
{{- define "developer-dashboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "developer-dashboard.ingress-host" -}}
{{- $ingressSubdomain := include "developer-dashboard.ingressSubdomain" . -}}
{{- if .Values.ingress.includeNamespace -}}
{{- printf "%s-%s.%s" .Values.host .Release.Namespace $ingressSubdomain -}}
{{- else -}}
{{- printf "%s.%s" .Values.host $ingressSubdomain -}}
{{- end -}}
{{- end -}}

{{- define "developer-dashboard.route-port" -}}
{{- if .Values.sso.enabled -}}
{{ printf "proxy" }}
{{- else -}}
{{ printf "http" }}
{{- end -}}
{{- end -}}

{{- define "developer-dashboard.route-termination" -}}
{{- if .Values.sso.enabled -}}
{{ printf "reencrypt" }}
{{- else -}}
{{ printf "edge" }}
{{- end -}}
{{- end -}}

{{- define "developer-dashboard.clusterType" -}}
{{ $clusterType := default .Values.global.clusterType .Values.clusterType }}
{{- if or (eq $clusterType "openshift") (regexFind "^ocp.*" $clusterType) -}}
{{- "openshift" -}}
{{- else -}}
{{- "kubernetes" -}}
{{- end -}}
{{- end -}}

{{- define "developer-dashboard.ingressSubdomain" -}}
{{- default .Values.global.ingressSubdomain .Values.ingressSubdomain -}}
{{- end -}}

{{- define "developer-dashboard.tlsSecretName" -}}
{{- default .Values.global.tlsSecretName .Values.tlsSecretName -}}
{{- end -}}
