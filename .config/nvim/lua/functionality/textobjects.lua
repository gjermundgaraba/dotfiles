local M = {}

local var_textobjs = require "various-textobjs"

function M.select_outer_quote()
  var_textobjs.anyQuote "outer"
end

function M.select_inner_quote()
  var_textobjs.anyQuote "inner"
end

return M
