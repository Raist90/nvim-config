return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("diffview").setup({
      use_icons = true,
    })
  end,
}
