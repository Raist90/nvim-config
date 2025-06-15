return {
  "projekt0n/github-nvim-theme",
  priority = 1000,
  config = function()
    require("github-theme").setup({
      options = {
        transparent = false,
      }
    })

    vim.cmd("colorscheme github_dark_tritanopia")
  end
}
