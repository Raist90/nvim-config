local M = {}

local map = function(keys, func, desc, mode)
  mode = mode or "n"
  vim.keymap.set(mode, keys, func, { desc = desc })
end

M.map = map

return M
