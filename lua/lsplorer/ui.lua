local config = require("lsplorer.config")
local ls = require("lsplorer.ls")
local util = require("lsplorer.util")

local ui = {}
local U = {}

function U.refresh_lsplorer(path, buf)
  vim.bo[buf].modifiable = true
  local output = ls.run(path)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  util.highlights(buf)
  vim.bo[buf].modifiable = false
end

---@param cwd string
function U.init_buf(cwd)
  vim.cmd("wincmd =")
  vim.cmd(config.opts.ui.side .. " vertical " .. config.opts.ui.width .. "new")
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

---@param win number
---@param path string
function U.init_winbar(win, path)
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
function U.init_win(win, path)
  if not path then
    path = util.project_root
  end

  U.init_winbar(win, path)

  vim.wo[win].winhighlight = "Normal:LsplorerNormal,Directory:LsplorerDirectory"

  vim.api.nvim_buf_set_name(0, "Lsplorer")
  vim.wo.winfixwidth = true
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.bo.modifiable = false
  vim.cmd("wincmd =")
end

ui.init_win = U.init_win
ui.init_winbar = U.init_winbar
ui.init_buf = U.init_buf
ui.refresh_lsplorer = U.refresh_lsplorer
return ui
