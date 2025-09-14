local settings = {
  paddings = 2,
  group_paddings = 5,
  icons = "NerdFont", -- Seems unecessary for me
  font = require "helpers.default_font",
}

settings.monitors = {
  -- Hardcoded UUIDs (no name fallbacks)
  main_uuid = "D736B4F3-6B19-4626-917F-468415D0FEE3",
  builtin_uuid = "37D8832A-2D66-02CA-B9F7-8F30A301B230", -- Built-in display UUID

  -- Side displays: workspace per display UUID
  workspace_by_display_uuid = {
    ["37D8832A-2D66-02CA-B9F7-8F30A301B230"] = "S", -- Built-in
    ["5EF1B949-9D1D-4576-A13B-E52CE9626CB2"] = "V", -- DELL U3425WE
  },
}

return settings
