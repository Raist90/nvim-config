---@diagnostic disable: missing-fields
return {
  "folke/snacks.nvim",
  priority = 1000,
  enabled = true,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    indent = {
      enabled = true,
      indent = {
        hl = "SnacksIndent",
        -- char = "┊",
      },
      animate = {
        enabled = false,
      },
      scope = {
        enabled = false,
      },
    },
    input = { enabled = true },
    lazygit = { enabled = false },
    notifier = { enabled = true },
    quickfile = { enabled = false },
    picker = { enabled = false },
    scope = { enabled = true },
    statuscolumn = { enabled = false },
    terminal = {
      enabled = false,
      win = {
        height = 0.3,
      },
    },
    words = { enabled = false },
    zen = { enabled = true, toggles = { dim = false }, show = { statusline = true } },
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
        width = 0.7,
        height = 0,
        backdrop = {
          transparent = false,
          blend = 70,
        },
        keys = { q = false },
        zindex = 40,
        wo = {
          winhighlight = "NormalFloat:Normal",
        },
        w = {
          snacks_main = true,
        },
      },
    },
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
