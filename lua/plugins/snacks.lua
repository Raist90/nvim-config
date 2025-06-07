return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = {
      enabled = true,
      indent = {
        char = "┊",
        hl = "SnacksIndent",
      }
    },
    input = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = false },
    terminal = {
      enabled = true,
      win = {
        height = 0.3,
      }
    },
    words = { enabled = true },
    styles = {
      notification = {
        relative = "editor",
        border = "single",
      },
      notification_history = {
        relative = "editor",
        border = "single",
      }
    }
  },
  keys = {
    {
      "<leader>c",
      function()
        require("snacks").bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bc",
      function()
        require("snacks").bufdelete.other()
      end,
      desc = "Delete Other Buffers",
    },
  },
}
