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
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fF", function()
			require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
		end, { desc = "Find all files" })
		vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
		vim.keymap.set("n", "<leader>fw", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		vim.keymap.set("n", "<leader>jj", builtin.jumplist, {})
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "[S]earch document [S]ymbols" })
		vim.keymap.set("n", "<leader>ft", builtin.colorscheme, { desc = "[S]earch [T]hemes" })

		vim.keymap.set("n", "<leader>fW", function()
			require("telescope.builtin").live_grep({
				additional_args = function()
					return { "--hidden", "--no-ignore" }
				end,
			})
		end, { desc = "Find all words" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>f/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })
	end,
}
