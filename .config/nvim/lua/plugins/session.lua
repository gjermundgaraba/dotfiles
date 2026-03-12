local disable_session_for_startup = vim.env.NVIM_OPEN_EXPLORER == "1"

return {
  {
    "rmagatti/auto-session",
    lazy = false,
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      enabled = not disable_session_for_startup,
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      auto_restore = true,
    },
  },
}
