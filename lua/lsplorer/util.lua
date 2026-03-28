local util = {}
local U = {}

-- Track project root (updated when user changes directory)
U.project_root = vim.fn.getcwd()

function U.find_lsplorer_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("Lsplorer$") and vim.api.nvim_buf_is_loaded(buf) then
      return buf
    end
  end
  return nil
end

function U.is_open()
  return U.find_lsplorer_buf() ~= nil
end

---@param str string
function U.is_valid_selection(str)
  -- Allow ".." for parent directory navigation
  return str and str ~= "." and str ~= ""
end

---@param str string
-- Returns true if the string is non-empty and not just whitespace
function U.is_empty_string(str)
  return str:match("^%s*$")
end

function U.update_project_root()
  U.project_root = vim.fn.getcwd()
end

function U.highlights(buf)
  vim.api.nvim_buf_call(buf, function()
    vim.cmd([[
      syntax clear
      syntax match Directory "^.*/$"
      syntax match GitUntracked "??$"
      syntax match GitModified "M$"
      syntax match GitModifiedStaged " MS$"
      syntax match GitAdded "A$"
      syntax match GitDeleted "D$"
      syntax match GitRenamed "R$"
      syntax match GitCopied "C$"
      syntax match GitUnmerged "UU$"
      highlight default link GitUntracked DiagnosticWarn
      highlight default link GitModified DiagnosticError
      highlight default link GitModifiedStaged DiagnosticOk
      highlight default link GitAdded DiagnosticOk
      highlight default link GitDeleted DiagnosticError
      highlight default link GitRenamed DiagnosticHint
      highlight default link GitCopied DiagnosticHint
      highlight default link GitUnmerged DiagnosticError
    ]])
  end)
end

---@param msg string
---@param level "error"|"info"|"warn"
function U.log(msg, level)
  local levels = { error = vim.log.levels.ERROR, info = vim.log.levels.INFO, warn = vim.log.levels.WARN }
  local log_level = levels[level] or vim.log.levels.INFO
  vim.notify("Lsplorer: " .. msg, log_level)
end

---@generic T
---@param list T[]
---@param predicate fun(item: T): boolean
---@return T|nil found_item, integer|nil found_index
function U.find(list, predicate)
  for i, item in ipairs(list) do
    if predicate(item) then
      return item, i
    end
  end
  return nil, nil
end

util.is_open = U.is_open
util.is_valid_selection = U.is_valid_selection
util.is_empty_string = U.is_empty_string
util.highlights = U.highlights
util.update_project_root = U.update_project_root
util.log = U.log
util.project_root = U.project_root
util.find = U.find
util.find_lsplorer_buf = U.find_lsplorer_buf

return util
