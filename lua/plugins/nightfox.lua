return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local palette = require("nightfox.palette").load("nightfox")

    require("nightfox").setup({
      groups = {
        all = {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
          FloatBorder = { fg = palette.bg3, bg = "NONE" },
          StatusLine = { bg = "NONE" },
          StatusLineNC = { bg = "NONE" },

          Pmenu = { bg = "NONE" },
          BlinkCmpMenuBorder = { link = "FloatBorder" },
          BlinkCmpMenuSelection = { bg = palette.sel1 }, -- Selected item
          BlinkCmpDoc = { bg = "NONE" },
          BlinkCmpDocBorder = { link = "FloatBorder" },
          BlinkCmpDocSeparator = { bg = "NONE" },
          BlinkCmpSignatureHelp = { bg = "NONE" },
          BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },

          LazyGitBorder = { link = "FloatBorder" },
          LazyGitFloat = { fg = palette.white, bg = "NONE" },

          FzfLuaBorder = { link = "FloatBorder" },
          FzfLuaPointer = { fg = palette.blue, bg = "NONE" }, -- The > cursor indicator
          SnacksIndent = { fg = palette.bg3 },

          WinBar = { bg = "NONE", style = "bold" },
          WinBarNC = { bg = "NONE" },
          VertSplit = { link = "FloatBorder" },
          WinSeparator = { link = "FloatBorder" },

          WinbarActive = { fg = palette.blue, bg = "NONE" },
          LsplorerWinbarActive = { fg = palette.blue, bg = "NONE" },
          LsplorerWinbarInactive = { fg = palette.comment, bg = "NONE" },

          -- Lsplorer window highlights (for active/inactive states)
          LsplorerNormal = { fg = palette.fg1, bg = "NONE" },
          LsplorerNormalNC = { fg = palette.comment, bg = "NONE" },
          LsplorerDirectory = { fg = palette.blue, bg = "NONE" },
          LsplorerDirectoryNC = { fg = palette.comment, bg = "NONE" },

          TabLine = { bg = "NONE" },
          TabLineFill = { bg = "NONE" },
          TabLineSel = { fg = palette.blue, bg = "NONE" },
        },
        -- carbonfox = {},
      },
      options = {
        transparent = true,
      },
    })
    vim.cmd("colorscheme nightfox")
  end,
}
