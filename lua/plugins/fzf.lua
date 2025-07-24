return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  config = function()
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { desc = desc })
    end

    require("fzf-lua").setup({
      "telescope",
      actions = {
        files = {
          ["ctrl-h"] = require("fzf-lua").actions.toggle_ignore,
          ["enter"]  = require("fzf-lua").actions.file_edit_or_qf,
          ["ctrl-t"] = require("fzf-lua").actions.file_tabedit,
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
          border = "single"
        }
      }
    })

    map("<leader>ff", require("fzf-lua").files, "Find Files")
    map("<leader>fw", require("fzf-lua").live_grep, "Find Words")
    map("<leader>f/", require("fzf-lua").grep_curbuf, "Grep current buffer")
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
    map("<leader>fc", require("fzf-lua").commands, "Search commands")
    map("<leader>fm", require("fzf-lua").manpages, "Search manpages")
    map("gr", require("fzf-lua").lsp_references, "Find references")
    map("<leader>fk", require("fzf-lua").keymaps, "Find keymaps")
    map("<leader>la", function()
      -- https://github.com/ibhagwan/fzf-lua/issues/1295
      require("fzf-lua").lsp_code_actions({
        previewer = false,
      })
    end, "LSP Code Actions")

    require("fzf-lua").register_ui_select()
  end,
}
