---
{{- $desc := env.Getenv "DESCRIPTION" -}}
{{- if $desc }}
description: {{ $desc | strings.Quote }}
{{- end }}
trigger: {{ env.Getenv "TRIGGER" }}
---

{{ template "body" . }}


