return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	-- or, branch = '0.1.x',
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})
		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "ui-select")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fF", function()
			require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
		end, { desc = "Find all files" })
		vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Find Git Files" })
		vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Find Words" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search Help" })
		vim.keymap.set("n", "<leader>jj", builtin.jumplist, { desc = "Search Jumplist" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Search Diagnostics" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Search Keymaps" })
		vim.keymap.set("n", "<leader>ft", builtin.colorscheme, { desc = "Search Themes" })

		vim.keymap.set("n", "<leader>fW", function()
			require("telescope.builtin").live_grep({
				additional_args = function()
					return { "--hidden", "--no-ignore" }
				end,
			})
		end, { desc = "Find all Words" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>f/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "Search in open files" })
	end,
}
