return {
	{
		"zbirenbaum/copilot.lua",
		name = "copilot.lua",
		lazy = true,
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<Tab>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				markdown = true,
			},
		},
	},
}
