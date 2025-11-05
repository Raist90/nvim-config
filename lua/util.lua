local M = {}

---@param keys string
---@param func string|function
---@param desc string
---@param mode? string
local map = function(keys, func, desc, mode)
  mode = mode or "n"
  vim.keymap.set(mode, keys, func, { desc = desc })
end

M.map = map

return M
