return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
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
        }
      },
      custom_highlights = function(colors)
        return {
          BlinkCmpMenu = { bg = colors.base },
          BlinkCmpMenuBorder = { bg = colors.base, fg = colors.blue },
          BlinkCmpDoc = { bg = colors.base },
          BlinkCmpDocBorder = { bg = colors.base, fg = colors.blue },
        }
      end,
    })
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
