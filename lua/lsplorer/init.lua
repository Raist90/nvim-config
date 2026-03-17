local util = require("lsplorer.util")

-- Lsplorer is a simple file explorer for Neovim using eza for listing files.
local Lsplorer = {}
local L = {}

function L.open()
  -- Get directory from current buffer BEFORE creating scratch buffer
  local bufpath = vim.api.nvim_buf_get_name(0)
  if bufpath == "" then
    bufpath = vim.fn.getcwd()
  end
  local cwd = vim.fn.fnamemodify(bufpath, ":p:h")

  vim.cmd("topleft vertical 30new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.buflisted = false
  vim.bo.filetype = "lsplorer"

  -- Store the directory in buffer variable so autocmd can use it
  vim.b.lsplorer_dir = cwd

  local output = util.ls_output_with_parent(cwd)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
  util.setup_highlights(0)

  -- Set up winbar with project name
  local currwin = vim.api.nvim_get_current_win()
  util.setup_winbar(currwin, util.project_root)

  -- Set window-local highlight overrides for dimming when inactive
  vim.wo[currwin].winhighlight = "Normal:LsplorerNormal,Directory:LsplorerDirectory"

  vim.api.nvim_buf_set_name(0, "Lsplorer")
  vim.wo.winfixwidth = true
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.bo.modifiable = false
  vim.cmd("wincmd =")

  require("lsplorer.keymaps").load()
  require("lsplorer.autocmd").setup()
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

L.is_open = function()
  local lsplorer_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("Lsplorer$") and vim.api.nvim_buf_is_loaded(buf) then
      lsplorer_buf = buf
      break
    end
  end
  return lsplorer_buf ~= nil
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
  if L.is_open() then
    L.close()
  else
    L.open()
  end
end

-- Public API
Lsplorer.toggle = L.toggle_lsplorer
return Lsplorer
