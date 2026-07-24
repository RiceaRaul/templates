{{/*
Expand the name of the chart.
*/}}
{{- define "kavita.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kavita.namespace" -}}
{{- .Values.global.namespace }}
{{- end }}

{{- define "kavita.labels" -}}
app: kavita
app.kubernetes.io/name: kavita
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
