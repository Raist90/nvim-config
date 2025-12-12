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

---Pad a string with spaces on both sides.
---@param str string The content to pad.
---@param left number? Number of spaces to add on the left. Default is 2.
---@param right number? Number of spaces to add on the right. Default is 2.
---@return string The padded content.
local function pad_string(str, left, right)
  left = left or 1
  right = right or 1
  return string.rep(" ", left) .. str .. string.rep(" ", right)
end

---Trim leading and trailing whitespace from a string.
---@param s string The string to trim.
---@return string The trimmed string.
local function trim_string(s)
  return s:match("^%s*(.-)%s*$")
end

M.on_attach = on_attach
M.map = map
M.pad_string = pad_string
M.trim_string = trim_string

return M
