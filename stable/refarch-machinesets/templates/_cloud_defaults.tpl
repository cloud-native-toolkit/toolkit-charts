{{/*
Default list of Zones per CloudProvider
*/}}

{{- define "cloud.zones" -}}
{{- if eq .Values.cloudProvider.name "aws" -}}
{{ default (list "a" "b" "c") .Values.cloud.zones }}
{{- end }}
{{- if eq $.Values.cloudProvider.name "azure" -}}
{{ default (list "1" "2" "3") .Values.cloud.zones }}
{{- end }}
{{- if eq $.Values.cloudProvider.name "ibmcloud" -}}
{{ default (list "1" "2" "3") .Values.cloud.zones }}
{{- end }}
{{- end }}

{{/*
Default Cloud Region
*/}}

{{- define "cloud.region" -}}
{{- if eq $.Values.cloudProvider.name "aws" -}}
{{ $region := required "You need to provide the cloud.region of your cluster in your values.yaml file" $.Values.cloud.region }}
{{- end -}}
{{- if eq $.Values.cloudProvider.name "azure" -}}
{{ $region := required "You need to provide the cloud.region of your cluster in your values.yaml file" $.Values.cloud.region }}
{{- end -}}
{{- if eq $.Values.cloudProvider.name "ibmcloud" -}}
{{ $region := required "You need to provide the cloud.region of your cluster in your values.yaml file" $.Values.cloud.region }}
{{- end -}}
{{ default "none" $.Values.cloud.region }}
{{- end -}}
