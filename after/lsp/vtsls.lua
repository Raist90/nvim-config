local on_attach = require("util").on_attach

return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
  on_attach = on_attach,
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
