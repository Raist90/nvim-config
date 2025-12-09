return {
  "nvim-mini/mini.files",
  version = false,
  config = function()
    require("mini.files").setup({
      -- Disable icons
      content = { prefix = function() end },

      -- Open mini files in the current work directory
      vim.keymap.set("n", "<leader>e", function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
        MiniFiles.open(path)
        MiniFiles.reveal_cwd()
      end, { desc = "Open Files" }),

      mappings = {
        close = "q",
        reset = "<BS>",
      },

      options = {
        use_as_default_explorer = false,
      },
    })
  end,
}
