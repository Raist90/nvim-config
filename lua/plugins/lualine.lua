return {
  "nvim-lualine/lualine.nvim",
  enabled = false,
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
        icons_enabled = false,
        globalstatus = true,
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
        lualine_a = {
          {
            "mode",
            fmt = function(s)
              return mode_map[s] or s
            end,
          },
        },
        lualine_b = { "branch", "diff", { "diagnostics", icons_enabled = false } },
        lualine_c = {
          { "filename", path = 1 },
        },
        lualine_x = {},
        lualine_y = {
          { "lsp_status" },
        },
        lualine_z = {
          function()
            return os.date("%R")
          end,
        },
      },
      extensions = { "fzf", "quickfix" },
    })
  end,
}
