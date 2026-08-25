return {
  dir = "~/Examples/zen",
  name = "Zen",
  enabled = true,
  event = "BufEnter",
  config = function()
    require("zen").setup()

    vim.keymap.set("n", "<leader>Z", function()
      require("zen").toggle()
    end, { desc = "Toggle Zen Mode" })
  end,
}
