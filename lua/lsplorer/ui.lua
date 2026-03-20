local ls = require("lsplorer.ls")
local util = require("lsplorer.util")

local ui = {}
local U = {}

function U.refresh_lsplorer(path, buf)
  local output = ls.run(path)

  -- Update Lsplorer buffer
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  util.highlights(buf)
  vim.bo[buf].modifiable = false
end

ui.refresh_lsplorer = U.refresh_lsplorer
return ui
