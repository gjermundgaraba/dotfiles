---
{{- $desc := env.Getenv "DESCRIPTION" -}}
{{- if $desc }}
description: {{ $desc | strings.Quote }}
{{- end }}
alwaysApply: {{ env.Getenv "ALWAYS_APPLY" }}
---

{{ template "body" . }}


