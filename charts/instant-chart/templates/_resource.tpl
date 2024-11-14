{{/*
Return resource kind. Ex: Deployment, DaemonSet, StatefulSet, CronJob.
*/}}
{{- define "instant-chart.resource.kind" -}}
{{- .Values.kind | default "Deployment" | title -}}
{{- end -}}
