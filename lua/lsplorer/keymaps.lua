local action = require("lsplorer.action")

local keymaps = {}

local load = function()
  vim.keymap.set("n", "<CR>", action.open_file, { buffer = 0, noremap = true, silent = true })
  vim.keymap.set("n", "a", action.add_file, { buffer = 0, noremap = true, silent = true })
  vim.keymap.set("n", "r", action.rename_file, { buffer = 0, noremap = true, silent = true })
  vim.keymap.set("n", "d", action.delete_file, { buffer = 0, noremap = true, silent = true })
end

keymaps.load = load
return keymaps
