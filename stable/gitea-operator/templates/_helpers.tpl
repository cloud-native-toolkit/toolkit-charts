{{/*
Expand the name of the chart.
*/}}
{{- define "gitea.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gitea.fullname" -}}
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
{{- define "operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "operator.labels" -}}
helm.sh/chart: {{ include "operator.chart" . }}
{{ include "gitea.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gitea.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gitea.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{- define "operator.cluster-type" -}}
{{ default .Values.global.clusterType .Values.clusterType }}
{{- end -}}

{{/*
Default OLM Namespace
*/}}
{{- define "operator.default-olm-namespace" -}}
{{- if eq (include "operator.cluster-type" .) "ocp4" -}}
{{ default "openshift-marketplace" .Values.global.olmNamespace }}
{{- else -}}
{{ default "olm" .Values.global.olmNamespace }}
{{- end -}}
{{- end -}}

{{/*
OLM Namespace
*/}}
{{- define "operator.olm-namespace" -}}
{{ default (include "operator.default-olm-namespace" .) .Values.olmNamespace }}
{{- end -}}

{{/*
Default Operator Namespace
*/}}
{{- define "operator.default-operator-namespace" -}}
{{- if eq (include "operator.cluster-type" .) "ocp4" -}}
{{ default "openshift-operators" .Values.global.operatorNamespace }}
{{- else -}}
{{ default "operators" .Values.global.operatorNamespace }}
{{- end -}}
{{- end -}}

{{/*
Operator Namespace
*/}}
{{- define "operator.operator-namespace" -}}
{{- if .Values.namespaceScoped -}}
{{ .Release.Namespace }}
{{- else -}}
{{ default (include "operator.default-operator-namespace" .) .Values.operatorNamespace }}
{{- end -}}
{{- end -}}

{{/*
Operator Source
*/}}
{{- define "operator.source" -}}
{{ .Values.ocpCatalog.source }}
{{- end -}}

{{/*
Operator channel
*/}}
{{- define "operator.channel" -}}
{{ .Values.ocpCatalog.channel }}
{{- end -}}

{{/*
Operator name
*/}}
{{- define "operator.name" -}}
{{ .Values.ocpCatalog.name }}
{{- end -}}
