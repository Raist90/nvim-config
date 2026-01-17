-- https://mhpark.me/posts/update-treesitter-main/
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  -- commit = "15b3416cc1f557c4932468e512a0bd45871167bc",
  build = ":TSUpdate",
  branch = "main",
  config = function()
    local ts = require("nvim-treesitter")
    -- NOTE: markdown and markdown_inline are excluded because they cause
    -- Neovim to hang when parsing LSP hover floats and notification windows.
    -- This is likely a bug in the parser or incompatibility with float buffers.
    -- Basic markdown highlighting still works without treesitter.
    -- The commented commit had a compatible parser
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
      -- "markdown",
      -- "markdown_inline",
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
      pattern = parsers,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
