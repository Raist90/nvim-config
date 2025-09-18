return {
  settings = {
    tailwindCSS = {
      classFunctions = { "cva", "cx" },
      experimental = {
        classRegex = {
          { "([\"'`][^\"'`]*.*?[\"'`])", "[\"'`]([^\"'`]*).*?[\"'`]" },
        },
      },
    },
  },
}
