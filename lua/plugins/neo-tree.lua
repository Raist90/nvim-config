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
		buffers = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
		},

		close_if_last_window = true,

		filesystem = {
			filtered_items = {
				visible = true,
				hide_gitignored = false,
				hide_hidden = false,
			},

			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},

			hijack_netrw_behavior = "open_current",

			window = {
				mappings = {
					["\\"] = "close_window",
				},
			},
		},
		git_status = {
			symbols = {
				-- Change type
				added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
				modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
				deleted = "✖", -- this can only be used in the git_status source
				renamed = "󰁕", -- this can only be used in the git_status source
				-- Status type
				untracked = "",
				ignored = "",
				unstaged = "󰄱",
				staged = "",
				conflict = "",
			},
		},

		source_selector = {
			winbar = true,
		},
	},
}
