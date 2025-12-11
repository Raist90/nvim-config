local M = {}

local function on_attach(client, bufnr)
  local disable_format = {
    vtsls = true,
    vue_ls = true,
  }

  if disable_format[client.name] then
    client.server_capabilities.documentFormattingProvider = false
  end
end

---@param keys string
---@param func string|function
---@param desc string
---@param mode? string
local map = function(keys, func, desc, mode)
  mode = mode or "n"
  vim.keymap.set(mode, keys, func, { desc = desc })
end

M.on_attach = on_attach
M.map = map

return M
