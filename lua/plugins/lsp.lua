local on_attach = require("util").on_attach

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "b0o/schemastore.nvim",
  },
  config = function()
    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = true })
    local detach_augroup = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if
          not client
          or not client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
        then
          return
        end

        -- Several clients may attach to the same buffer; register once per buffer.
        if vim.b[event.buf].lsp_highlight_attached then
          return
        end
        vim.b[event.buf].lsp_highlight_attached = true

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })
      end,
    })

    -- Registered once (not per buffer), so detaching one buffer doesn't drop
    -- the autocmds belonging to other buffers.
    vim.api.nvim_create_autocmd("LspDetach", {
      group = detach_augroup,
      callback = function(event)
        vim.api.nvim_buf_call(event.buf, vim.lsp.buf.clear_references)
        vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event.buf })
        vim.b[event.buf].lsp_highlight_attached = nil
      end,
    })

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
