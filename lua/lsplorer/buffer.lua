local ls = require("lsplorer.ls")
local util = require("lsplorer.util")

local buffer = {}
local B = {}

---@param cwd string
function B.init(cwd)
  vim.cmd("topleft vertical 30new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.buflisted = false
  vim.bo.filetype = "lsplorer"

  -- Store the directory in buffer variable so autocmd can use it
  vim.b.lsplorer_dir = cwd

  local output = ls.run(cwd)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
  util.highlights(0)
end

buffer.init = B.init
return buffer
