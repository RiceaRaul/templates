{{/*
Expand the name of the chart.
*/}}
{{- define "valkey.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "valkey.namespace" -}}
{{- .Values.global.namespace }}
{{- end }}

{{- define "valkey.labels" -}}
app: valkey
app.kubernetes.io/name: valkey
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "valkey.authEnabled" -}}
{{- if or .Values.valkey.password .Values.valkey.existingSecret }}true{{ end }}
{{- end }}
