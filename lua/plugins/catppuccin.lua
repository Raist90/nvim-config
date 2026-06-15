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
      -- styles = {
      --   keywords = { "bold" },
      -- },
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
          indent_scope_color = "surface2",
        },
        flash = true,
      },
      custom_highlights = function(colors)
        return {
          CursorLineNr = { fg = colors.text, style = { "bold" } },
          WinSeparator = { fg = colors.surface0 },

          BlinkCmpMenuBorder = { link = "FloatBorder" },

          LazyGitBorder = { fg = colors.lavender },

          WinbarActive = { bg = colors.surface0, fg = colors.blue, style = { "bold" } },
          WinbarInactive = { fg = colors.subtext1, style = { "bold" } },
          WinbarModeActive = { bg = colors.blue, fg = colors.base, style = { "bold" } },
          WinbarModeInactive = { bg = colors.subtext0, fg = colors.base },
          WinbarSeparator = { fg = colors.surface0 },
          WinbarSeparatorActive = { bg = colors.surface0, fg = colors.blue },
          WinbarSeparatorInactive = { fg = colors.subtext0 },

          Statusline = { fg = colors.text },
          StatuslineGit = { bg = colors.base, fg = colors.blue, style = { "bold" } },
          StatuslineLSP = { bg = colors.base, fg = colors.text },
          StatuslineLSPBracket = { bg = colors.base, fg = colors.blue, style = { "bold" } },
          StatuslineError = { fg = colors.red },
          StatuslineWarn = { fg = colors.yellow },
          StatuslineInfo = { fg = colors.sky },
          StatuslineHint = { fg = colors.teal },
          StatuslineTime = { fg = colors.text, style = { "bold" } },

          LsplorerNormal = { fg = colors.text },
          LsplorerNormalNC = { fg = colors.subtext0 },
          LsplorerDirectory = { fg = colors.blue },
          LsplorerDirectoryNC = { fg = colors.subtext0 },
          LsplorerSelected = { fg = colors.text },
          LsplorerWinbarActive = { fg = colors.blue },
          LsplorerWinbarInactive = { fg = colors.subtext0 },
        }
      end,
    })
    vim.cmd("colorscheme catppuccin-mocha")
  end,
}
