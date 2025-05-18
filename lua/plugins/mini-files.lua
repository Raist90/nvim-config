return {
	"echasnovski/mini.files",
	version = false,
	config = function()
		require("mini.files").setup({
			vim.keymap.set("n", "<leader>e", function()
				require("mini.files").open()
			end, { desc = "Open files" }),

			mappings = {
				close = "q",
				reset = "<BS>",
			},
		})
	end,
}
