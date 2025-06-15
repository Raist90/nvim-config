return {
  "echasnovski/mini.animate",
  event = "VeryLazy",
  cond = not (vim.g.neovide or vim.g.vscode),
  opts = function()
    -- don't use animate when scrolling with the mouse
    local mouse_scrolled = false
    for _, scroll in ipairs { "Up", "Down" } do
      local key = "<ScrollWheel" .. scroll .. ">"
      vim.keymap.set({ "", "i" }, key, function()
        mouse_scrolled = true
        return key
      end, { expr = true })
    end

    local animate = require "mini.animate"
    return {
      open = {
        enable = false,
      },
      close = {
        enable = false,
      },
      resize = {
        enable = false,
        timing = animate.gen_timing.linear { duration = 100, unit = "total" },
      },
      scroll = {
        enable = true,
        timing = animate.gen_timing.linear { duration = 150, unit = "total" },
        subscroll = animate.gen_subscroll.equal {
          predicate = function(total_scroll)
            if mouse_scrolled then
              mouse_scrolled = false
              return false
            end
            return total_scroll > 1
          end,
        },
      },
      cursor = {
        timing = animate.gen_timing.linear { duration = 80, unit = "total" },
      },
    }
  end,
}
