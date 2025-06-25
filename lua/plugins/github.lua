return {
  "projekt0n/github-nvim-theme",
  priority = 1000,
  config = function()
    require("github-theme").setup({
      options = {
        transparent = false,
      },
      palettes = {
        github_dark_tritanopia = {
          canvas = {
            default = "#0a0c10", -- This is the background color from github_dark_high_contrast
          }
        }
      },
      groups = {
        github_dark_tritanopia = {
          SnacksIndent = { fg = "#3C3C3C" }, -- This is the color for the indent lines
        }
      }
    })

    -- vim.cmd("colorscheme github_dark_tritanopia")
  end
}
