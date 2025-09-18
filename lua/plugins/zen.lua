return {
  "Raist90/zen.nvim",
  name = "Zen",
  enabled = false,
  event = "BufEnter",
  config = function()
    require("zen").setup()

    vim.keymap.set("n", "<leader>Z", function()
      require("zen").toggle()
    end, { desc = "Toggle Zen Mode" })
  end,
}
