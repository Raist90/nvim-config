-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  desc = "Highlight selection on yank",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Open help files in a vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

-- Disable auto commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("No auto comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Disable copilot suggestion when BlinkCmp menu is open
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    require("copilot.suggestion").dismiss()
    vim.b.copilot_suggestion_hidden = true
  end,
})

-- Re-enable copilot suggestion when BlinkCmp menu is closed
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
