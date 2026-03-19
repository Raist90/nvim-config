local util = {}
local U = {}

-- Track project root (updated when user changes directory)
U.project_root = vim.fn.getcwd()

function U.is_open()
  local lsplorer_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("Lsplorer$") and vim.api.nvim_buf_is_loaded(buf) then
      lsplorer_buf = buf
      break
    end
  end
  return lsplorer_buf ~= nil
end

function U.is_valid_filename(f)
  return f and f ~= "." and f ~= ""
  -- Allow ".." for parent directory navigation
end

function U.update_project_root()
  U.project_root = vim.fn.getcwd()
end

function U.highlights(buf)
  vim.api.nvim_buf_call(buf, function()
    vim.cmd([[
      syntax clear
      syntax match Directory "^.*/$"
    ]])
  end)
end

util.is_open = U.is_open
util.is_valid_filename = U.is_valid_filename
util.highlights = U.highlights
util.update_project_root = U.update_project_root
util.project_root = U.project_root

return util
