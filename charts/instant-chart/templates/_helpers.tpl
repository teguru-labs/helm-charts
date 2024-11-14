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
{{- end -}}

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
Get the first container.
Usage:
  {{- $container := (include "instant-chart.firstContainer" . | fromYaml).container -}}
*/}}
{{- define "instant-chart.firstContainer" -}}
{{- $container := dict -}}
{{- if gt (len .Values.containers) 0 -}}
  {{- $container = index .Values.containers 0 -}}
{{- end -}}
container: {{ toYaml $container | nindent 2 }}
{{- end -}}

{{/*
Get the first container port of the given container or default port.
Usage:
  {{- $port := (include "instant-chart.firstContainerPort" $container | fromYaml).port -}}
*/}}
{{- define "instant-chart.firstContainerPort" -}}
{{- $container := default dict . -}}
{{- $containerPort := 80 -}}
{{- if and $container.ports (gt (len .ports) 0) -}}
  {{- $containerPort = (index .ports 0).containerPort | default 80 -}}
{{- end -}}
port: {{ $containerPort }}
{{- end -}}

{{/*
Get the first service port or default port.
Usage:
  {{- $port := (include "instant-chart.firstServicePort" . | fromYaml).port -}}
*/}}
{{- define "instant-chart.firstServicePort" -}}
{{- $servicePort := 80 -}}
{{- with .Values.service -}}
  {{- if gt (len .ports) 0 -}}
    {{- $servicePort = (index .ports 0).port | default 80 -}}
  {{- else -}}
    {{- $container := (include "instant-chart.firstContainer" $ | fromYaml).container -}}
    {{- $servicePort = (include "instant-chart.firstContainerPort" $container | fromYaml).port -}}
  {{- end -}}
{{- end -}}
port: {{ $servicePort }}
{{- end -}}
