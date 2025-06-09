---@diagnostic disable: missing-fields
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
    zen = { enabled = true, toggles = { dim = false } },
    styles = {
      notification = {
        relative = "editor",
        border = "single",
      },
      notification_history = {
        relative = "editor",
        border = "single",
      },
      zen = {
        enter = true,
        fixbuf = false,
        minimal = false,
        width = 120,
        height = 0,
        backdrop = {
          transparent = false,
          blend = 99,
        },
        keys = { q = false },
        zindex = 40,
        wo = {
          winhighlight = "NormalFloat:Normal",
        },
        w = {
          snacks_main = true,
        },
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
