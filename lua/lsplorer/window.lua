local util = require("lsplorer.util")

local window = {}
local W = {}

---@param win number
---@param path string
function W.winbar(win, path)
  local win_title = vim.fn.fnamemodify(path, ":t")
  local win_width = vim.api.nvim_win_get_width(win)
  -- Truncate with ... if project name is longer than window width
  if #win_title > win_width then
    local max_len = win_width - 3 -- Reserve 3 chars for "..."
    if max_len > 0 then
      win_title = win_title:sub(1, max_len) .. "..."
    else
      win_title = "..."
    end
  end

  vim.wo[win].winbar = "%#LsplorerWinbarActive#" .. "~/" .. win_title
end

---@param win number
---@param path string?
function W.init(win, path)
  if not path then
    path = util.project_root
  end

  W.winbar(win, path)

  vim.wo[win].winhighlight = "Normal:LsplorerNormal,Directory:LsplorerDirectory"

  vim.api.nvim_buf_set_name(0, "Lsplorer")
  vim.wo.winfixwidth = true
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.bo.modifiable = false
  vim.cmd("wincmd =")
end

window.init = W.init
return window
