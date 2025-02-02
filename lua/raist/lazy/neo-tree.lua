-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
  -- Load this early on to hijack Netrw
  lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
    { "<leader>e", ":Neotree toggle reveal<CR>", desc = "Neotree reveal", silent = true },
	},
	opts = {
		filesystem = {
      hijack_netrw_behavior = "open_current",

			window = {
				mappings = {
					["\\"] = "close_window",
				},
			},
		},
	},
}
