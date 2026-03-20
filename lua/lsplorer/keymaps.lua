local action = require("lsplorer.actions")

local keymaps = {}

local load = function()
  vim.keymap.set("n", "<CR>", action.open_entry, { buffer = 0, noremap = true, silent = true })
  vim.keymap.set("n", "a", action.add_entry, { buffer = 0, noremap = true, silent = true })
  vim.keymap.set("n", "r", action.rename_entry, { buffer = 0, noremap = true, silent = true })
  vim.keymap.set("n", "d", action.delete_entry, { buffer = 0, noremap = true, silent = true })
end

keymaps.load = load
return keymaps
