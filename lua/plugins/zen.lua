return {
  dir = "~/Examples/zen",
  name = "Zen",
  enabled = true,
  event = "BufEnter",
  config = function()
    require("zen").setup({
      window = {
        width = 120,
        height = 1,
      },
      zindex = 40,
    })

    vim.keymap.set("n", "<leader>Z", function()
      require("zen").toggle()
    end, { desc = "Toggle Zen Mode" })
  end,
}
