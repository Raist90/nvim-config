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

          WinbarActive = { fg = colors.blue, style = { "bold" } },
          WinbarInactive = { fg = colors.subtext0 },

          Statusline = { fg = colors.text },
          StatuslineGit = { fg = colors.blue, style = { "bold" } },
          StatuslineError = { fg = colors.red },
          StatuslineWarn = { fg = colors.yellow },
          StatuslineInfo = { fg = colors.sky },
          StatuslineHint = { fg = colors.teal },
          StatuslineTime = { fg = colors.blue, style = { "bold" } },

          LsplorerNormal = { fg = colors.text },
          LsplorerNormalNC = { fg = colors.subtext0 },
          LsplorerDirectory = { fg = colors.blue },
          LsplorerDirectoryNC = { fg = colors.subtext0 },
          LsplorerWinbarActive = { fg = colors.blue },
          LsplorerWinbarInactive = { fg = colors.subtext0 },
        }
      end,
    })
    vim.cmd("colorscheme catppuccin-macchiato")
  end,
}
