return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    preview_config = {
      border = "single",
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, { desc = "Git: Next hunk" })

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, { desc = "Git: Previous hunk" })

      -- Actions
      map("n", "<leader>hs", gs.stage_hunk, { desc = "Git: Stage hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { desc = "Git: Reset hunk" })

      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Git: Stage hunk (visual)" })

      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Git: Reset hunk (visual)" })

      map("n", "<leader>hS", gs.stage_buffer, { desc = "Git: Stage buffer" })
      map("n", "<leader>hR", gs.reset_buffer, { desc = "Git: Reset buffer" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Git: Preview hunk" })
      map("n", "<leader>hi", gs.preview_hunk_inline, { desc = "Git: Preview hunk inline" })

      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, { desc = "Git: Blame line (full)" })

      map("n", "<leader>hd", gs.diffthis, { desc = "Git: Diff against index" })

      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, { desc = "Git: Diff against last commit" })

      map("n", "<leader>hQ", function()
        gs.setqflist("all")
      end, { desc = "Git: Populate quickfix list (all hunks)" })
      map("n", "<leader>hq", gs.setqflist, { desc = "Git: Populate quickfix list (current file)" })

      -- Toggles
      map("n", "<leader>ht", gs.toggle_deleted, { desc = "Git: Toggle deleted" })

      -- Text object
      map({ "o", "x" }, "ih", gs.select_hunk, { desc = "Git: Select hunk" })
    end,
  },
}
