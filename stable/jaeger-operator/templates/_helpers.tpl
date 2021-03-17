{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "operator.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "operator.labels" -}}
helm.sh/chart: {{ include "operator.chart" . }}
{{ include "operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Selector labels
*/}}
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
Operator Namespace
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
{{ default (include "operator.default-operator-namespace" .) .Values.operatorNamespace }}
{{- end -}}

{{/*
Operator Source
*/}}
{{- define "operator.source" -}}
{{- if eq (include "operator.cluster-type" .) "ocp4" -}}
{{ .Values.ocpCatalog.source }}
{{- else -}}
{{ .Values.operatorHub.source }}
{{- end -}}
{{- end -}}

{{/*
Operator channel
*/}}
{{- define "operator.channel" -}}
{{- if eq (include "operator.cluster-type" .) "ocp4" -}}
{{ .Values.ocpCatalog.channel }}
{{- else -}}
{{ .Values.operatorHub.channel }}
{{- end -}}
{{- end -}}

{{/*
Operator name
*/}}
{{- define "operator.catalog-name" -}}
{{- if eq (include "operator.cluster-type" .) "ocp4" -}}
{{ .Values.ocpCatalog.name }}
{{- else -}}
{{ .Values.operatorHub.name }}
{{- end -}}
{{- end -}}
