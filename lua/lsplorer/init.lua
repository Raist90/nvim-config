local autocmd = require("lsplorer.autocmd")
local buffer = require("lsplorer.buffer")
local keymaps = require("lsplorer.keymaps")
local util = require("lsplorer.util")
local window = require("lsplorer.window")

-- Lsplorer is a simple file explorer for Neovim using ls for listing files.
local Lsplorer = {}
local L = {}

function L.open()
  local bufpath = vim.api.nvim_buf_get_name(0)
  if bufpath == "" then
    bufpath = vim.fn.getcwd()
  end
  local cwd = vim.fn.fnamemodify(bufpath, ":p:h")
  buffer.init(cwd)

  local currwin = vim.api.nvim_get_current_win()
  window.init(currwin)

  keymaps.load()
  autocmd.setup()
end

vim.api.nvim_create_user_command("Lsplorer", function()
  L.open()
end, {})

L.focus = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_name(buf):match("Lsplorer$") then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

L.close = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local win_buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_name(win_buf):match("Lsplorer$") then
      vim.api.nvim_win_close(win, true)
      break
    end
  end
  vim.api.nvim_clear_autocmds({ group = "LsplorerAutoCmds" })
end

L.toggle_lsplorer = function()
  if util.is_open() then
    L.close()
  else
    L.open()
  end
end

-- Public API
Lsplorer.toggle = L.toggle_lsplorer
return Lsplorer
