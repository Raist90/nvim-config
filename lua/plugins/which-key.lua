return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VeryLazy", -- Sets the loading event to 'VimEnter'

	opts = {
		-- delay between pressing a key and opening which-key (milliseconds)
		-- this setting is independent of vim.opt.timeoutlen
		delay = 0,
		preset = "helix",
		icons = {
			-- set icon mappings to true if you have a Nerd Font
			mappings = vim.g.have_nerd_font,
		},

		spec = {
			{ "<leader>b", group = "Buffer" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>j", group = "Jump" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>w", group = "Window" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
