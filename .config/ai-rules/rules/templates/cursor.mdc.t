---
description: {{ env.Getenv "DESCRIPTION" | strings.Quote }}
alwaysApply: {{ env.Getenv "ALWAYS_APPLY" }}
---

{{ template "body" . }}


