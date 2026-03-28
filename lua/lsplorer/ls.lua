local git = require("lsplorer.git")
local util = require("lsplorer.util")

local ls = {}
local L = {}

---@param dir string
function L.run(dir)
  local output = {}

  if vim.fn.executable("ls") == 1 then
    local cmd = string.format("ls -1 %s", vim.fn.shellescape(dir))
    local entries = vim.fn.systemlist(cmd)
    local dirs, files = {}, {}
    for _, entry in ipairs(entries) do
      if vim.fn.isdirectory(dir .. "/" .. entry) == 1 then
        table.insert(dirs, entry .. "/")
      else
        local symbol = git.get_status_symbol(dir, entry)
        if symbol then
          table.insert(files, entry .. " " .. symbol)
        else
          table.insert(files, entry)
        end
      end
    end
    vim.list_extend(dirs, files)
    output = dirs
  else
    util.log("ls command not found. Falling back to Vim's readdir.", "warn")
  end

  -- Normalize paths for comparison
  local normalized_dir = vim.fn.fnamemodify(dir, ":p")
  local normalized_root = vim.fn.fnamemodify(util.project_root, ":p")

  -- If not at project root, prepend parent directory link
  if normalized_dir ~= normalized_root then
    table.insert(output, 1, "../")
  end

  return output
end

ls.run = L.run
return ls
