{{/*
Generate infra nodes tolerations
{{- $params := dict "Values" $.Values "Component" $component -}}
*/}}
{{- define "monitoring.placement" -}}
{{ printf "%s:" .Component }}
{{- if (default $.Values.global.labels $.Values.labels) }}
  {{ "nodeSelector:" -}}  
  {{ toYaml (default $.Values.global.labels $.Values.labels) | nindent 4 -}}
{{ end -}}
{{- if (default $.Values.global.taints $.Values.taints) }}
  {{ "tolerations:" -}}  
  {{- toYaml (default $.Values.global.taints $.Values.taints) | nindent 2 -}}
{{ end -}}
{{- end -}}
