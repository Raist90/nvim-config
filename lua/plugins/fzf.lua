local map = require("util").map

return {
  "ibhagwan/fzf-lua",
  config = function()
    require("fzf-lua").setup({
      "default",
      buffers = {
        formatter = "path.filename_first",
      },
      files = {
        formatter = "path.filename_first",
      },
      live_grep = {
        formatter = "path.filename_first",
      },
      actions = {
        files = {
          ["ctrl-h"] = require("fzf-lua").actions.toggle_ignore,
          ["enter"] = require("fzf-lua").actions.file_edit_or_qf,
        },
      },
      keymap = {
        buffers = {
          true,
          ["ctrl-q"] = "select-all+accept",
        },
        builtin = {
          true,
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          true,
          ["ctrl-d"] = "preview-page-down",
          ["ctrl-u"] = "preview-page-up",
          ["ctrl-q"] = "select-all+accept",
        },
      },
      defaults = {
        file_icons = false,
      },
      fzf_opts = {
        ["--layout"] = "reverse",
      },
      winopts = {
        border = "single",
        preview = {
          border = "single",
        },
      },
      fzf_colors = {
        ["gutter"] = "-1",
        ["fg+"] = { "fg", "FzfLuaCursorLine" },
        ["bg+"] = { "bg", "FzfLuaCursorLine" },
        ["hl+"] = { "fg", "FzfLuaSearch" },
        ["pointer"] = { "fg", "FzfLuaPointer" },
        ["marker"] = { "fg", "FzfLuaMarker" },
      },
    })

    map("<leader>ff", require("fzf-lua").files, "Find Files")
    map("<leader>fw", require("fzf-lua").live_grep, "Find Words")
    map("<leader>f/", require("fzf-lua").lgrep_curbuf, "Grep current buffer")
    map("<leader>gh", require("fzf-lua").git_bcommits, "Git History")
    map("<leader>fh", require("fzf-lua").git_hunks, "Find Git hunks")
    map("<leader>fb", require("fzf-lua").buffers, "Find buffers")
    map("<leader>fs", require("fzf-lua").lsp_document_symbols, "Find symbols")
    map("<leader>fS", require("fzf-lua").lsp_workspace_symbols, "Find all symbols")
    map("<leader>f?", require("fzf-lua").helptags, "Search help")
    map("<leader>fd", require("fzf-lua").diagnostics_document, "Find diagnostics")
    map("<leader>fD", require("fzf-lua").diagnostics_workspace, "Find all diagnostics")
    map("gd", require("fzf-lua").lsp_definitions, "Goto definition")
    map("gD", require("fzf-lua").lsp_declarations, "Goto declaration")
    map("gI", require("fzf-lua").lsp_implementations, "Goto implementation")
    map("gy", require("fzf-lua").lsp_definitions, "Goto type definition")
    map("<leader>jj", require("fzf-lua").jumps, "Search jumplist")
    map("<leader>ft", require("fzf-lua").colorschemes, "Search themes")
    map("<leader>fc", require("fzf-lua").git_commits, "Search git commits")
    map("<leader>fm", require("fzf-lua").manpages, "Search manpages")
    map("grr", require("fzf-lua").lsp_references, "Find references")
    map("<leader>fk", require("fzf-lua").keymaps, "Find keymaps")
    map("<leader>fq", require("fzf-lua").quickfix, "Find quickfix items")
    map("gra", function()
      -- https://github.com/ibhagwan/fzf-lua/issues/1295
      require("fzf-lua").lsp_code_actions({
        previewer = false,
      })
    end, "LSP Code Actions")

    require("fzf-lua").register_ui_select()
  end,
}
