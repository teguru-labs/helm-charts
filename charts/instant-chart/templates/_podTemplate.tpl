{{/*
Render Pod Template
*/}}
{{- define "instant-chart.podTemplate" -}}
metadata:
  labels:
    {{- include "instant-chart.labels" . | nindent 4 }}
spec:
  containers:
  {{- include "instant-chart.containers" (dict "containers" .Values.containers "prefix" "container" "imagePatches" .Values.imagePatches) | trim | nindent 2 -}}
  {{- with .Values.initContainers }}
  initContainers:
  {{- include "instant-chart.containers" (dict "containers" . "prefix" "init" "imagePatches" .Values.imagePatches) | trim | nindent 2 -}}
  {{- end }}
  {{- if .Values.volumes }}
  volumes:
  {{- include "instant-chart.volumes" . | nindent 2 -}}
  {{- end }}
  serviceAccountName: {{ include "instant-chart.serviceAccountName" . }}
  {{- if or .Values.registryLogin .Values.imagePullSecrets .Values.global.imagePullSecrets }}
  imagePullSecrets:
  {{- if .Values.registryLogin }}
  - name: {{ include "instant-chart.pullSecretName" . }}
  {{- end }}
  {{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
  {{- end }}
  {{- range .Values.imagePullSecrets }}
  - name: {{ . }}
  {{- end }}
  {{- end }}
  {{- with .Values.nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.nodeName }}
  nodeName: {{ . }}
  {{- end }}
  {{- with .Values.affinity }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.tolerations }}
  tolerations:
  {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.topologySpreadConstraints }}
  topologySpreadConstraints:
  {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.dnsConfig }}
  dnsConfig:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.hostAliases }}
  hostAliases:
  {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.overhead }}
  overhead:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.readinessGates }}
  readinessGates:
  {{- toYaml . | nindent 2 }}
  {{- end }}
  {{- with .Values.securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.restartPolicy }}
  restartPolicy: {{ .Values.restartPolicy }}
  {{- end }}
{{- end }}

{{/*
Generate the container definitions
Usage:
{{- include "instant-chart.containers" (dict "containers" .Values.containers "prefix" "container") | trim | nindent 6 -}}
*/}}
{{- define "instant-chart.containers" -}}
{{- $imagePatches := .imagePatches | default dict -}}
{{- range $index, $container := .containers }}
{{- $name := $container.name | default (printf "%s-%d" $.prefix $index) -}}
{{- if hasKey $imagePatches $name -}}
{{- $container = set $container "image" (index $imagePatches $name | default $container.image) -}}
{{- end -}}
{{- $defaultPort := (include "instant-chart.firstContainerPort" $container | fromYaml).port -}}
- name: {{ $name }}
  {{- omit $container "name" "livenessProbe" "readinessProbe" "startupProbe" | toYaml | nindent 2 }}
  {{- if hasKey $container "livenessProbe" }}
  livenessProbe:
    {{- include "instant-chart.probe" (dict
      "probe" $container.livenessProbe
      "defaultPort" $defaultPort
    ) | trim | nindent 4 }}
  {{- end }}
  {{- if hasKey $container "readinessProbe" }}
  readinessProbe:
    {{- include "instant-chart.probe" (dict
      "probe" $container.readinessProbe
      "defaultPort" $defaultPort
    ) | trim | nindent 4 }}
  {{- end }}
  {{- if hasKey $container "startupProbe" }}
  startupProbe:
    {{- include "instant-chart.probe" (dict
      "probe" $container.startupProbe
      "defaultPort" $defaultPort
    ) | trim | nindent 4 }}
  {{- end }}
{{- end -}}
{{- end -}}

{{/*
Generate the probe definition
Usage:
*/}}
{{- define "instant-chart.probe" -}}
{{- $probe := merge .probe (dict "tcpSocket" (dict "port" .defaultPort)) -}}
{{- $options := omit .probe "enabled" "httpGet" "exec" "grpc" "tcpSocket" -}}
{{- $options = merge $options (dict
  "initialDelaySeconds" 10
  "periodSeconds" 10
  "timeoutSeconds" 5
  "failureThreshold" 5
  "successThreshold" 1
) -}}
{{- if hasKey $probe "httpGet" }}
{{- $httpGet := merge $probe.httpGet (dict "path" "/" "port" .defaultPort) -}}
httpGet:
  {{- omit $httpGet "enabled" | toYaml | nindent 2 }}
{{- else if hasKey $probe "exec" -}}
{{- $exec := merge $probe.exec (dict "command" list) -}}
exec:
  {{- omit $exec "enabled" | toYaml | nindent 2 }}
{{- else if hasKey $probe "grpc" -}}
{{- $grpc := merge $probe.grpc (dict "port" .defaultPort) -}}
grpc:
  {{- omit $grpc "enabled" | toYaml | nindent 2 }}
{{- else if hasKey $probe "tcpSocket" -}}
{{- $tcpSocket := merge $probe.tcpSocket (dict "port" .defaultPort) -}}
tcpSocket:
  {{- omit $tcpSocket "enabled" | toYaml | nindent 2 }}
{{- end }}
{{- toYaml $options | nindent 0 }}
{{- end -}}
