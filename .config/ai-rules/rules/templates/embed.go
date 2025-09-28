package templates

import "embed"

// Files contains embedded platform templates.
//
//go:embed *.tmpl
var Files embed.FS
