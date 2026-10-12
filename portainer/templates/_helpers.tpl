{{/*
Expand the name of the chart.
*/}}
{{- define "portainer.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "portainer.namespace" -}}
{{- .Values.global.namespace }}
{{- end }}

{{- define "portainer.labels" -}}
app: portainer
app.kubernetes.io/name: portainer
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Secret holding the initial admin password; empty when the admin is created from the UI.
*/}}
{{- define "portainer.adminSecretName" -}}
{{- with .Values.portainer.adminPassword -}}
{{- if .existingSecret -}}
{{- .existingSecret -}}
{{- else if .password -}}
portainer-admin
{{- end -}}
{{- end -}}
{{- end }}
