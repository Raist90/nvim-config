vim.cmd.colorscheme("kanagawa-dragon")
vim.cmd("let g:netrw_banner = 0")

local opt = vim.opt

opt.expandtab = true
opt.nu = true
opt.relativenumber = true
opt.shiftwidth = 2
-- Don't show the mode, since it's already in the status line
opt.showmode = false
opt.smartindent = true
opt.tabstop = 2
opt.wrap = true
opt.confirm = true
opt.cursorline = true
opt.foldlevel = 99
opt.linebreak = true
opt.ruler = false
opt.undofile = true
opt.undolevels = 10000
opt.breakindent = true
opt.backup = false
opt.termguicolors = true

vim.schedule(function()
	opt.clipboard = "unnamedplus"
end)

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = "yes"

-- Decrease update time
opt.updatetime = 250
-- Decrease mapped sequence wait time
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
opt.inccommand = "split"

-- Nerd font icons
vim.g.have_nerd_font = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
