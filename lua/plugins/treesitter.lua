-- https://mhpark.me/posts/update-treesitter-main/
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  branch = "main",
  config = function()
    local ts = require("nvim-treesitter")
    local parsers = {
      "bash",
      "comment",
      "css",
      "diff",
      "dockerfile",
      "git_config",
      "gitcommit",
      "gitignore",
      "go",
      "html",
      "http",
      "javascript",
      "jsdoc",
      "json",
      "json5",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "regex",
      "scss",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    }

    for _, parser in ipairs(parsers) do
      ts.install(parser)
    end

    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
    vim.api.nvim_command("set nofoldenable")

    vim.api.nvim_create_autocmd("FileType", {
      -- Add 'typescriptreact' to the list of filetypes that use the 'tsx' parser
      pattern = vim.list_extend(vim.deepcopy(parsers), { "typescriptreact" }),
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
