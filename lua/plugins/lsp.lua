local on_attach = require("util").on_attach

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "b0o/schemastore.nvim",
  },
  config = function()
    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config({
      float = { border = "single", source = "if_many" },
      severity_sort = false,
      underline = true,
      virtual_lines = false,
      virtual_text = false,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    -- enable snippet
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- lsp server config

    -- html: disable wrap line
    vim.lsp.config("html", {
      settings = {
        html = {
          format = {
            wrapLineLength = 0,
          },
        },
      },
    })
    -- json: validate using schema and pull from schemastore
    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })
    -- lua: recognize "vim" and "mp" global
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim", "mp" },
          },
        },
      },
      on_attach = on_attach,
    })

    vim.lsp.config("vue_ls", {
      settings = {
        vue = {
          server = {
            includeLanguages = { "vue", "typescript" },
          },
        },
      },
      init_options = {
        -- https://github.com/mason-org/mason-lspconfig.nvim/issues/587
        typescript = {
          tsdk = "",
        },
        vue = {
          hybridMode = false,
        },
      },
      on_attach = on_attach,
    })

    vim.lsp.config("emmet_language_server", {
      filetypes = { "html", "css", "typescriptreact", "javascriptreact", "vue" },
    })

    vim.lsp.config("eslint", {
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "graphql",
        "gql",
      },
    })
  end,
}
