{{/*
Return resource kind. Ex: Deployment, DaemonSet, StatefulSet, CronJob.
*/}}
{{- define "instant-chart.resource.kind" -}}
{{- .Values.kind | default "Deployment" | title -}}
{{- end -}}

{{/*
Render the update strategy
*/}}
{{- define "instant-chart.resource.updateStrategy" -}}
{{- $kind := include "instant-chart.resource.kind" . -}}
{{- if .Values.updateStrategy -}}
type: {{ .Values.updateStrategy.type | default "RollingUpdate" }}
{{- if .Values.updateStrategy.rollingUpdate }}
rollingUpdate:
  {{- if and .Values.updateStrategy.rollingUpdate.maxSurge (ne $kind "StatefulSet") }}
  maxSurge: {{ .Values.updateStrategy.rollingUpdate.maxSurge }}
  {{- end }}
  {{- if .Values.updateStrategy.rollingUpdate.maxUnavailable }}
  maxUnavailable: {{ .Values.updateStrategy.rollingUpdate.maxUnavailable }}
  {{- end }}
  {{- if and .Values.updateStrategy.rollingUpdate.partition (eq $kind "StatefulSet") }}
  partition: {{ .Values.updateStrategy.rollingUpdate.partition }}
  {{- end }}
{{- end }}
{{- else -}}
{}
{{- end -}}
{{- end -}}
