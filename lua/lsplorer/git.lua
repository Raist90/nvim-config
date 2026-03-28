local util = require("lsplorer.util")

local git = {}

local function get_relative_path(dir, filename)
  local rel_path = dir:gsub("^" .. util.project_root .. "/?", "")
  return rel_path == "" and filename or (rel_path .. "/" .. filename)
end

local function get_status(dir)
  local cmd = vim.fn.systemlist(string.format("git -C %s status --porcelain", vim.fn.shellescape(dir)))
  -- vim.notify("Git status output: " .. table.concat(cmd, "\n"), vim.log.levels.DEBUG)

  -- https://git-scm.com/docs/git-status#_output
  local status_map = {
    ["??"] = "??", -- untracked
    [" M"] = "M", -- modified in work tree (unstaged)
    ["M "] = "MS", -- modified in index (staged)
    ["A "] = "A", -- added to index (staged)
    ["D "] = "D", -- deleted from index (staged)
    ["R "] = "R", -- renamed in index (staged)
    ["C "] = "C", -- copied in index (staged)
    ["UU"] = "UU", -- unmerged, both modified
  }

  local symbols = {}
  for _, line in ipairs(cmd) do
    local status, file = line:match("^(..)%s+(.+)$")
    if status and file then
      symbols[file] = status_map[status] or status -- default to raw status if not in map so that we can debug it
    end
  end
  return symbols
end

local G = {}

---@param dir string
---@param filename string
---@return string?
-- Returns the git symbol for a given file in the specified directory, or nil if the file is not tracked by git.
function G.get_status_symbol(dir, filename)
  local git_symbols = get_status(dir)
  local rel_path = get_relative_path(dir, filename)
  return git_symbols[rel_path]
end

function G.strip_status(filename)
  return filename:match("^[^%s]+")
end

git.get_status_symbol = G.get_status_symbol
git.strip_status = G.strip_status
return git
