vim.g.mapleader = " " -- Set leader key before Lazy
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

keymap("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

keymap("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Mason" })
keymap("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Lazy" })

keymap("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git Blame Line" })
keymap("n", "<leader>gB", "<cmd>Gitsigns blame<cr>", { desc = "Git Blame" })

keymap("n", "<leader>qo", function()
  vim.cmd("copen")
end, { desc = "Open Quickfix List" })

keymap("n", "<leader>qc", function()
  vim.cmd("cclose")
end, { desc = "Close Quickfix List" })

keymap("n", "<leader>nh", function()
  require("snacks").notifier.show_history()
end, { desc = "Show Notification History" })

keymap("n", "<leader>Z", function()
  require("snacks").zen()
end, { desc = "Toggle Zen Mode" })

keymap("n", "<leader>ld", function()
  vim.diagnostic.open_float(nil, { focusable = true, scope = "cursor" })
end, { desc = "Open Diagnostic Float" })

keymap("n", "<leader>Co", "<cmd>CopilotChatOpen<cr>", { desc = "Copilot Chat Prompts" })
vim.keymap.set("n", "<leader>Cc", "<cmd>CopilotChatClose<cr>", { desc = "Copilot Chat Close" })

keymap("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Open Terminal" })
