return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      float = {
        solid = true,
        transparent = true,
      },
      no_italic = true,
      transparent_background = true,
      integrations = {
        blink_cmp = {
          style = "bordered"
        },
        fzf = true,
        neotree = true,
        dashboard = true,
        notify = true,
        treesitter = true,
        which_key = true,
        gitsigns = true,
        mason = true,
        mini = {
          enabled = true,
        },
        snacks = {
          enabled = true,
          indent_scope_color = "lavender",
        },
        flash = true,
      },
    })
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
