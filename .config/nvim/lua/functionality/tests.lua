local M = {}

function M.open_test()
  require("neotest").output_panel.open()
  require("neotest").summary.open()
end

function M.test_nearest()
  require("neotest").run.run()
end

return M
