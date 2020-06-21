{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ocp-route.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "ocp-route.labels" -}}
helm.sh/chart: {{ include "ocp-route.chart" . }}
{{ include "ocp-route.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "ocp-route.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ocp-route.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "ocp-route.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "ocp-route.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Cluster type
*/}}
{{- define "ocp-route.clusterType" -}}
{{ default .Values.global.clusterType .Values.clusterType }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "ocp-route.isOpenShift" -}}
{{- $clusterType := include "ocp-route.clusterType" . -}}
{{- if or (or (eq $clusterType "ocp3") (eq $clusterType "ocp4")) (eq $clusterType "openshift") -}}
true
{{- else -}}
false
{{- end -}}
{{- end -}}
