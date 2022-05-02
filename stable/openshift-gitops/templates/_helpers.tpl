{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "operator.name" -}}
{{ include "operator.catalog-name" . }}
{{- end -}}

{{- define "operator.argocd-name" -}}
{{ "argocd-cluster" }}
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
{{- if .Values.createdBy }}
created-by: {{ .Values.createdBy | quote }}
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
{{ default "openshift-marketplace" .Values.global.olmNamespace }}
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
{{ default "openshift-operators" .Values.global.operatorNamespace }}
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
{{ .Values.subscription.source }}
{{- end -}}

{{/*
Operator channel
*/}}
{{- define "operator.channel" -}}
{{ .Values.subscription.channel }}
{{- end -}}

{{/*
Operator catalog name
*/}}
{{- define "operator.catalog-name" -}}
{{ .Values.subscription.name }}
{{- end -}}
