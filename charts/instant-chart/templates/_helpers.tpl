{{/*
Generate standard labels
Usage:
{{ include "instant-chart.labels" . }}
*/}}
{{- define "instant-chart.labels" -}}
{{- $labels := merge (include "common.labels.standard" . | fromYaml) (.Values.global.labels | default dict) -}}
{{- with .Values.global.appVersion }}
{{- $labels = merge $labels (dict "app.kubernetes.io/version" .) -}}
{{- end }}
{{- toYaml $labels -}}
{{- end -}}

{{/*
Generate match labels
Usage:
{{ include "instant-chart.matchLabels" . }}
*/}}
{{- define "instant-chart.matchLabels" -}}
{{- $matchLabels := include "common.labels.matchLabels" . | fromYaml -}}
{{- $customLabels := .Values.global.labels | default (dict) -}}
{{- merge $matchLabels $customLabels | toYaml -}}
{{- end -}}

{{/*
Create the name of the service account to use
Usage:
{{ include "instant-chart.serviceAccountName" . }}
*/}}
{{- define "instant-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the pull secret
Usage:
{{ include "instant-chart.pullSecretName" . }}
*/}}
{{- define "instant-chart.pullSecretName" -}}
{{- include "common.names.fullname" . }}-pull-secret
{{- end }}

{{/*
Generate the .dockerconfigjson content for Docker registry authentication.
Usage:
{{ include "instant-chart.dockerconfigjson" $credentials }}
*/}}
{{- define "instant-chart.dockerconfigjson" -}}
{{- $auths := dict -}}
{{- range . }}
  {{- if and .server .username .password }}
    {{- $auth := printf "%s:%s" .username .password | b64enc -}}
    {{- $authData := dict "username" .username "password" .password "auth" $auth -}}
    {{- if .email -}}
      {{- $authData = merge $authData (dict "email" .email) -}}
    {{- end }}
    {{- $auths = merge $auths (dict (index . "server") $authData) -}}
  {{- end }}
{{- end }}
{{- dict "auths" $auths | toJson | b64enc -}}
{{- end }}

{{/*
Clean volumes by removing .persistentVolumeClaim.requests
*/}}
{{- define "instant-chart.volumes" -}}
{{- $cleanVolumes := list -}}
{{- range .Values.volumes -}}
  {{- if and .persistentVolumeClaim .persistentVolumeClaim.requests -}}
    {{- $pvc := omit .persistentVolumeClaim "requests" -}}
    {{- $volume := set . "persistentVolumeClaim" $pvc -}}
    {{- $cleanVolumes = append $cleanVolumes $volume -}}
  {{- else -}}
    {{- $cleanVolumes = append $cleanVolumes . -}}
  {{- end -}}
{{- end -}}
{{- $cleanVolumes | toYaml | nindent 0 | trim -}}
{{- end -}}

{{/*
Generate the container definitions
Usage:
{{- include "instant-chart.containers" (dict "containers" .Values.containers "prefix" "container") | trim | nindent 6 -}}
*/}}
{{- define "instant-chart.containers" -}}
{{- range $index, $container := .containers }}
- name: {{ $container.name | default (printf "%s-%d" $.prefix $index) }}
  {{- omit $container "name" | toYaml | nindent 2 }}
{{- end -}}
{{- end -}}
