return { -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  event = "VeryLazy", -- Sets the loading event to 'VimEnter'

  opts = {
    -- delay between pressing a key and opening which-key (milliseconds)
    -- this setting is independent of vim.opt.timeoutlen
    delay = 0,
    preset = "helix",
    icons = {
      -- set icon mappings to true if you have a Nerd Font
      -- mappings = vim.g.have_nerd_font,
      mappings = false,
    },

    spec = {
      { "<leader>b", group = "Buffer" },
      { "<leader>C", group = "Copilot Chat" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Hunk" },
      { "<leader>j", group = "Jump" },
      { "<leader>l", group = "LSP" },
      { "<leader>n", group = "Notification" },
      { "<leader>o", group = "Opencode" },
      { "<leader>p", group = "Packages" },
      { "<leader>t", group = "Terminal" },
      { "<leader>q", group = "Quickfix" },
      { "<leader>w", group = "Window" },
    },

    ---@type wk.Win.opts
    win = {
      border = "single",
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
