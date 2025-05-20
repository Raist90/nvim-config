return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- short mode
    local mode_map = {
      ["NORMAL"] = "NOR",
      ["O-PENDING"] = "N?",
      ["INSERT"] = "INS",
      ["VISUAL"] = "VIS",
      ["V-BLOCK"] = "VB",
      ["V-LINE"] = "VL",
      ["V-REPLACE"] = "VR",
      ["REPLACE"] = "R",
      ["COMMAND"] = "!",
      ["SHELL"] = "SH",
      ["TERMINAL"] = "T",
      ["EX"] = "X",
      ["S-BLOCK"] = "SB",
      ["S-LINE"] = "SL",
      ["SELECT"] = "SEL",
      ["CONFIRM"] = "Y?",
      ["MORE"] = "M",
    }

    require("lualine").setup({
      options = {
        -- no section seperator
        -- and pipe as component seperator
        component_separators = "|",
        section_separators = "",
        -- disable lualine at file explorer pane, and homepage
        disabled_filetypes = { "NvimTree", "alpha" },

        -- get catppuccin color
        theme = "catppuccin",
      },
      sections = {
        lualine_a = { { "mode", fmt = function(s) return mode_map[s] or s end } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          { "filename", path = 1 },
        },
        lualine_x = {
          { "encoding", fmt = function(s) return s ~= "utf-8" and s end },
          {
            "fileformat",
            icons_enabled = false,
            fmt = function(s) return s ~= "unix" and s end
          },
        },
        -- stylua: ignore end
        lualine_y = { { "filetype" } },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "filename", path = 1 },
        },
        lualine_x = { "filetype" },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
