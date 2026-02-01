local eza_output_with_parent = require("lsplorer.util").eza_output_with_parent

-- Lsplorer is a simple file explorer for Neovim using eza for listing files.
local L = {}

-- Actions
L.open_file = require("lsplorer.action").open_file
L.refresh_lsplorer = require("lsplorer.action").refresh_lsplorer
L.add_file = require("lsplorer.action").add_file
L.rename_file = require("lsplorer.action").rename_file
L.delete_file = require("lsplorer.action").delete_file

function L.open_lsplorer()
  -- Get directory from current buffer BEFORE creating scratch buffer
  local buf_path = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(buf_path or vim.fn.getcwd(), ":p:h")

  vim.cmd("topleft vertical 30new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.buflisted = false
  vim.bo.filetype = "lsplorer"

  -- Store the directory in buffer variable so autocmd can use it
  vim.b.lsplorer_dir = dir

  local output = eza_output_with_parent(dir)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
  require("lsplorer.util").setup_highlights(0)

  -- Set up winbar with project name
  local win = vim.api.nvim_get_current_win()
  require("lsplorer.util").setup_winbar(win, require("lsplorer.util").project_root)

  -- Set window-local highlight overrides for dimming when inactive
  vim.wo[win].winhighlight = "Normal:LsplorerNormal,Directory:LsplorerDirectory"

  vim.api.nvim_buf_set_name(0, "Lsplorer")
  vim.bo.readonly = true
  vim.wo.winfixwidth = true
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.cmd("wincmd =")

  -- Set up keymaps
  vim.keymap.set("n", "<CR>", L.open_file, { buffer = 0, noremap = true, silent = true })
  vim.keymap.set("n", "a", L.add_file, { buffer = 0, noremap = true, silent = true })
  vim.keymap.set("n", "r", L.rename_file, { buffer = 0, noremap = true, silent = true })
  vim.keymap.set("n", "d", L.delete_file, { buffer = 0, noremap = true, silent = true })

  require("lsplorer.autocmd").setup()
end

vim.api.nvim_create_user_command("Lsplorer", function()
  L.open_lsplorer()
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
  local explorer_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("Lsplorer$") and vim.api.nvim_buf_is_loaded(buf) then
      explorer_buf = buf
      break
    end
  end
  return explorer_buf ~= nil
end

L.close_lsplorer = function()
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
    L.close_lsplorer()
  else
    L.open_lsplorer()
  end
end

return L
