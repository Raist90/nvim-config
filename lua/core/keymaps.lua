vim.g.mapleader = " " -- Set leader key before Lazy
vim.g.maplocalleader = " "

local map = require("util").map

map("<C-h>", "<C-w>h", "Go to Left Window")
map("<C-j>", "<C-w>j", "Go to Lower Window")
map("<C-k>", "<C-w>k", "Go to Upper Window")
map("<C-l>", "<C-w>l", "Go to Right Window")

map("<leader>pm", "<cmd>Mason<cr>", "Mason")
map("<leader>pl", "<cmd>Lazy<cr>", "Lazy")

map("<leader>gb", "<cmd>Gitsigns blame_line<cr>", "Git Blame Line")
map("<leader>gB", "<cmd>Gitsigns blame<cr>", "Git Blame")

map("<leader>qo", function()
  vim.cmd("copen")
end, "Open Quickfix List")

map("<leader>qc", function()
  vim.cmd("cclose")
end, "Close Quickfix List")

map("<leader>nh", function()
  require("snacks").notifier.show_history()
end, "Show Notification History")

map("<leader>Z", function()
  require("snacks").zen()
end, "Toggle Zen Mode")

map("<leader>ld", function()
  vim.diagnostic.open_float(nil, { focusable = true, scope = "cursor" })
end, "Open Diagnostic Float")

map("<leader>Co", function()
  require("CopilotChat").open()
end, "Copilot Chat Prompts")

map("<leader>Cc", function()
  require("CopilotChat").close()
end, "Copilot Chat Close")

map("<leader>tt", function()
  vim.cmd("terminal")
end, "Open Terminal")
