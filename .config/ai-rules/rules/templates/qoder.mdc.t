---
{{- $desc := env.Getenv "DESCRIPTION" -}}
{{- if $desc }}
description: {{ $desc | strings.Quote }}
{{- end }}
trigger: {{ env.Getenv "TRIGGER" }}
{{- $aa := env.Getenv "ALWAYS_APPLY" -}}
{{- if $aa }}
alwaysApply: {{ $aa }}
{{- end }}
---

{{ template "body" . }}
