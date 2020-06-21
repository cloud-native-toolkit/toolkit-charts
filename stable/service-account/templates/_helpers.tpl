{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "service-account.name" -}}
{{- default .Release.Name .Values.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "service-account.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "service-account.labels" -}}
helm.sh/chart: {{ include "service-account.chart" . }}
{{ include "service-account.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "service-account.selectorLabels" -}}
app.kubernetes.io/name: {{ include "service-account.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "service-account.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "service-account.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Cluster type
*/}}
{{- define "service-account.clusterType" -}}
{{ default .Values.global.clusterType .Values.clusterType }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "service-account.isOpenShift" -}}
{{- $clusterType := include "service-account.clusterType" . -}}
{{- if or (or (eq $clusterType "ocp3") (eq $clusterType "ocp4")) (eq $clusterType "openshift") -}}
true
{{- else -}}
false
{{- end -}}
{{- end -}}
