return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end,
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
            languages = { "vue" },
            location = vim.fn.stdpath("data")
              .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
            name = "@vue/typescript-plugin",
          },
        },
      },
    },
  },
}
