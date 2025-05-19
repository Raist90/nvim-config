vim.g.mapleader = " " -- Set leader key before Lazy
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

-- Move to window using the <ctrl> hjkl keys
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Window management
keymap("n", "<leader>wv", "<C-W>v", { desc = "Split Window Right", remap = true })
keymap("n", "<leader>ww", "<C-W>w", { desc = "Next Window", remap = true })

-- Package management
keymap("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Mason" })
keymap("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Git
keymap("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git Blame Line" })
keymap("n", "<leader>gB", "<cmd>Gitsigns blame<cr>", { desc = "Git Blame" })
