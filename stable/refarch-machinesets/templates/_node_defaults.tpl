

{{- define "node.taints" -}}
{{- if and (eq .Name "storage") $.Values.cloud.storageNodes.taints }}
taints:
{{- toYaml $.Values.cloud.storageNodes.taints | nindent 6 -}}
{{- end -}}
{{- if and (eq .Name "infra") $.Values.cloud.infraNodes.taints }}
taints:
{{- toYaml $.Values.cloud.infraNodes.taints | nindent 6 }}
{{- end -}}
{{- if and (eq .Name "cp4x") $.Values.cloud.cloudpakNodes.taints }}
taints:
{{- toYaml $.Values.cloud.cloudpakNodes.taints | nindent 6 -}}
{{- end -}}
{{- end -}}


{{- define "node.labels" -}}
{{- if and (eq .Name "storage") $.Values.cloud.storageNodes.labels }}
metadata:
  labels:
{{- toYaml $.Values.cloud.storageNodes.labels | nindent 10 -}}
{{- end -}}
{{- if and (eq .Name "infra") $.Values.cloud.infraNodes.labels }}
metadata:
  labels:
{{- toYaml $.Values.cloud.infraNodes.labels | nindent 10 -}}
{{- end -}}
{{- if and (eq .Name "cp4x") $.Values.cloud.cloudpakNodes.labels }}
metadata:
  labels:
{{- toYaml $.Values.cloud.cloudpakNodes.labels | nindent 10 -}}
{{- end -}}
{{- end -}}