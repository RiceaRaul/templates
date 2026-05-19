{{/*
Expand the name of the chart.
*/}}
{{- define "n8n.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "n8n.namespace" -}}
{{- .Values.global.namespace }}
{{- end }}

{{- define "n8n.labels" -}}
app: n8n
app.kubernetes.io/name: n8n
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
