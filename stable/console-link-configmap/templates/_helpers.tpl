{{/*
Expand the name of the chart.
*/}}
{{- define "console-link-configmap.name" -}}
{{- printf "%s-config" (required "A value is required for the `name` variable" .Values.name | default "cm") }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "console-link-configmap.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "console-link-configmap.labels" -}}
helm.sh/chart: {{ include "console-link-configmap.chart" . }}
{{ include "console-link-configmap.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "console-link-configmap.selectorLabels" -}}
app.kubernetes.io/name: {{ include "console-link-configmap.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "console-link-configmap.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "console-link-configmap.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "console-link-configmap.section" -}}
{{- default "Cloud-Native Toolkit" (default .Values.global.section .Values.section) }}
{{- end }}

{{- define "console-link-configmap.location" -}}
{{- default "ApplicationMenu" (default .Values.global.location .Values.location) }}
{{- end }}

{{- define "console-link-configmap.category" -}}
{{- default .Values.global.category .Values.category }}
{{- end }}

{{- define "console-link-configmap.displayName" -}}
{{- default (.Values.name | replace "-" " " | title) .Values.displayName }}
{{- end }}
