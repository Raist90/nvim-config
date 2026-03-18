local opt = vim.opt

vim.g.netrw_banner = 0
vim.g.netrw_keepdir = 0
vim.g.netrw_winsize = 15

opt.winborder = "single"

-- Don't show the ~ at the end of the buffer
opt.fillchars:append({ eob = " " })

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

-- Configure how new splits should be opened
opt.splitright = true

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
opt.inccommand = "split"

-- Diff options
-- See `:help diffopt`
opt.diffopt = {
  "filler",
  "internal",
  "algorithm:histogram",
  "indent-heuristic",
}

-- Nerd font icons
vim.g.have_nerd_font = true

-- Minimal number of screen lines to keep above and below the cursor.
-- opt.scrolloff = 10

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Enable virtual text for diagnostics
vim.diagnostic.config({ virtual_text = true })
