{{/*
Expand the name of the chart.
*/}}
{{- define "ollama-stack.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ollama-stack.namespace" -}}
{{- .Values.global.namespace }}
{{- end }}

{{- define "ollama-stack.webui.labels" -}}
app: open-webui
app.kubernetes.io/name: open-webui
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
