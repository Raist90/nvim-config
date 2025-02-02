vim.cmd.colorscheme("tokyobones")

local opt = vim.opt

opt.expandtab = true
opt.nu = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.showmode = false
opt.smartindent = true
opt.tabstop = 2
opt.wrap = true
opt.confirm = true
opt.cursorline = true
opt.foldlevel = 99
opt.linebreak = true
opt.ruler = false
opt.undolevels = 10000

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
