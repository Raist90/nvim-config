return {
  'nvim-mini/mini.indentscope',
  version = '*',
  config = function()
    require("mini.indentscope").setup()

    -- Disable for certain filetypes
    vim.api.nvim_create_autocmd({ "FileType" }, {
      desc = "Disable indentscope for certain filetypes",
      callback = function()
        local ignore_filetypes = {
          "snacks_dashboard",
          "help",
          "lazy",
          "mason",
          "notify",
          "fzf",
          "markdown",
        }
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
          vim.b.miniindentscope_disable = true
        end
      end
    })
  end
}
