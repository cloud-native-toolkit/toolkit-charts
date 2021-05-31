{{/*
Generate infra nodes tolerations
{{- $params := dict "Values" $.Values "Component" $component -}}
*/}}
{{- define "monitoring.placement" -}}
{{ printf "%s:" .Component }}
{{- if (default $.Values.global.infraNodes.labels $.Values.infraNodes.labels) }}
  {{ "nodeSelector:" -}}  
  {{ toYaml (default $.Values.global.infraNodes.labels $.Values.infraNodes.labels) | nindent 4 -}}
{{ end -}}
{{- if (default $.Values.global.infraNodes.taints $.Values.infraNodes.taints) }}
  {{ "tolerations:" -}}  
  {{- toYaml (default $.Values.global.infraNodes.taints $.Values.infraNodes.taints) | nindent 2 -}}
{{ end -}}
{{- end -}}
