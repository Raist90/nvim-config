return {
  "catppuccin/nvim",
  enabled = true,
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
          style = "bordered",
        },
        diffview = true,
        fzf = true,
        neotree = true,
        dashboard = true,
        notify = true,
        treesitter = true,
        which_key = true,
        gitsigns = {
          enabled = true,
          transparent = true,
        },
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
      custom_highlights = function(colors)
        return {
          LazyGitBorder = { fg = colors.lavender },

          WinbarNC = { fg = colors.overlay0, bg = colors.base },
          WinbarNormal = { fg = colors.text, bg = colors.base },
          WinbarFilename = { fg = colors.base, bg = colors.blue, style = { "bold" } },
          WinbarLocation = { fg = colors.blue, bg = colors.none },
        }
      end,
    })
    vim.cmd("colorscheme catppuccin-macchiato")
  end,
}
