local autocmd = require("lsplorer.autocmd")
local keymaps = require("lsplorer.keymaps")
local ui = require("lsplorer.ui")
local util = require("lsplorer.util")

-- Lsplorer is a simple file explorer for Neovim using ls for listing files.
local Lsplorer = {}
local L = {}

function L.open()
  local bufpath = vim.api.nvim_buf_get_name(0)
  if bufpath == "" then
    bufpath = vim.fn.getcwd()
  end
  local cwd = vim.fn.fnamemodify(bufpath, ":p:h")
  ui.init_buf(cwd)

  local currwin = vim.api.nvim_get_current_win()
  ui.init_win(currwin)

  keymaps.load()
  autocmd.setup()
end

vim.api.nvim_create_user_command("Lsplorer", function()
  L.toggle_lsplorer()
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

L.autostart = function()
  local args = vim.fn.argv()
  local first_arg = args[1] or ""

  if first_arg ~= "" and vim.fn.isdirectory(first_arg) == 1 then
    vim.cmd("bd!")

    local cwd = vim.fn.fnamemodify(first_arg, ":p:h")
    ui.init_buf(cwd)

    local currwin = vim.api.nvim_get_current_win()
    ui.init_win(currwin)

    keymaps.load()
    autocmd.setup()
  end
end

-- Open lsplorer on startup when opening a directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    L.autostart()
  end,
})

Lsplorer.toggle = L.toggle_lsplorer
return Lsplorer
