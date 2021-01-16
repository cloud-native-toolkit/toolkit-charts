{{/*
Expand the name of the chart.
*/}}
{{- define "starter-kit.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "starter-kit.fullname" -}}
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
{{- define "starter-kit.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "starter-kit.labels" -}}
helm.sh/chart: {{ include "starter-kit.chart" . }}
{{ include "starter-kit.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "starter-kit.selectorLabels" -}}
app.kubernetes.io/name: {{ include "starter-kit.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "starter-kit.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "starter-kit.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "starter-kit.host" -}}
{{- $chartName := include "starter-kit.name" . -}}
{{- $host := default $chartName .Values.ingress.host -}}
{{- $subdomain := .Values.ingress.subdomain | default .Values.global.ingressSubdomain -}}
{{- if .Values.ingress.namespaceInHost -}}
{{- printf "%s-%s.%s" $host .Release.Namespace $subdomain -}}
{{- else -}}
{{- printf "%s.%s" $host $subdomain -}}
{{- end -}}
{{- end -}}

{{- define "starter-kit.tlsSecretName" -}}
{{- $secretName := .Values.ingress.tlsSecretName | default .Values.global.tlsSecretName -}}
{{- if $secretName }}
{{- printf "%s" $secretName -}}
{{- else -}}
{{- printf "" -}}
{{- end -}}
{{- end -}}

{{- define "starter-kit.resources" -}}
{{- if .Values.resources -}}
{{ toYaml .Values.resources }}
{{- else -}}
{{ include "starter-kit.default-resources" . }}
{{- end -}}
{{- end -}}

{{- define "starter-kit.default-resources" -}}
{{- $runtime := .Values.runtime -}}
{{- if eq $runtime "golang" -}}
limits:
  cpu: 200m
  memory: 256Mi
requests:
  cpu: 100m
  memory: 128Mi
{{- else if or (eq $runtime "js") (eq $runtime "nodejs") -}}
limits:
  cpu: 500m
  memory: 512Mi
requests:
  cpu: 100m
  memory: 128Mi
{{- else if or (or (eq $runtime "openjdk") (eq $runtime "spring")) (eq $runtime "openliberty") -}}
limits:
  cpu: 500m
  memory: 1024Mi
requests:
  cpu: 100m
  memory: 256Mi
{{- else if eq $runtime "python" -}}
limits:
  cpu: 500m
  memory: 512Mi
requests:
  cpu: 100m
  memory: 128Mi
{{- else -}}
limits:
  cpu: 500m
  memory: 1024Mi
requests:
  cpu: 100m
  memory: 128Mi
{{- end -}}
{{- end -}}
