{{/*
Expand the name of the chart.
*/}}
{{- define "zot.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "zot.namespace" -}}
{{- .Values.global.namespace }}
{{- end }}

{{- define "zot.labels" -}}
app: zot
app.kubernetes.io/name: zot
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "zot.htpasswdSecretName" -}}
{{- .Values.zot.auth.existingSecret | default "zot-htpasswd" }}
{{- end }}

{{/*
Render config.json from values, then deep-merge zot.configOverrides on top.
*/}}
{{- define "zot.config" -}}
{{- $z := .Values.zot -}}
{{- $storage := dict "rootDirectory" "/var/lib/zot" "gc" $z.storage.gc "gcDelay" $z.storage.gcDelay "gcInterval" $z.storage.gcInterval "dedupe" $z.storage.dedupe -}}
{{- $http := dict "address" "0.0.0.0" "port" ($z.service.targetPort | toString) -}}
{{- if $z.externalUrl -}}
{{- $_ := set $http "externalUrl" $z.externalUrl -}}
{{- end -}}
{{- if $z.auth.enabled -}}
{{- if and (not $z.auth.existingSecret) (not $z.auth.htpasswd) -}}
{{- fail "zot.auth.enabled is true: set zot.auth.htpasswd (htpasswd -nbB <user> '<pass>') or zot.auth.existingSecret" -}}
{{- end -}}
{{- $actions := list "read" "create" "update" "delete" -}}
{{- $repoPolicy := dict "policies" (list (dict "users" $z.auth.adminUsers "actions" $actions)) "defaultPolicy" $z.auth.defaultPolicy -}}
{{- if $z.auth.anonymousPull -}}
{{- $_ := set $repoPolicy "anonymousPolicy" (list "read") -}}
{{- end -}}
{{- $_ := set $http "auth" (dict "htpasswd" (dict "path" "/etc/zot/htpasswd")) -}}
{{- $_ := set $http "accessControl" (dict "repositories" (dict "**" $repoPolicy) "adminPolicy" (dict "users" $z.auth.adminUsers "actions" $actions)) -}}
{{- end -}}
{{- $ext := dict -}}
{{- if $z.extensions.ui -}}
{{- $_ := set $ext "ui" (dict "enable" true) -}}
{{- end -}}
{{- if $z.extensions.search -}}
{{- $search := dict "enable" true -}}
{{- if $z.extensions.cve.enabled -}}
{{- $_ := set $search "cve" (dict "updateInterval" $z.extensions.cve.updateInterval) -}}
{{- end -}}
{{- $_ := set $ext "search" $search -}}
{{- end -}}
{{- if $z.extensions.scrub -}}
{{- $_ := set $ext "scrub" (dict "enable" true) -}}
{{- end -}}
{{- $cfg := dict "distSpecVersion" "1.1.1" "storage" $storage "http" $http "log" (dict "level" $z.logLevel) "extensions" $ext -}}
{{- mustMergeOverwrite $cfg (deepCopy ($z.configOverrides | default dict)) | toPrettyJson -}}
{{- end }}
