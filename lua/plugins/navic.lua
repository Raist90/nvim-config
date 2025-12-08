return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("nvim-navic").setup({
      depth_limit = 3,
      depth_limit_indicator = "..",
      icons = { enabled = false },
      safe_output = true,
    })
  end,
}
