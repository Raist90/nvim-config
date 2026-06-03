-- local git = require("lsplorer.git")
local util = require("lsplorer.util")

local scan = {}
local L = {}

---@param dir string
function L.run(dir)
  local dirs, files = {}, {}
  local handle = vim.uv.fs_scandir(dir)
  if handle then
    while true do
      local name, type = vim.uv.fs_scandir_next(handle)
      if not name then break end
      -- vim.uv.fs_stat follows symlinks automatically
      local stat = vim.uv.fs_stat(dir .. "/" .. name)
      if stat and stat.type == "directory" then
        table.insert(dirs, name .. "/")
      else
        -- local symbol = git.get_status_symbol(dir, name)
        -- if symbol then
        --   table.insert(files, name .. " " .. symbol)
        -- else
        table.insert(files, name)
        -- end
      end
    end
  else
    util.log("cannot open directory: " .. dir, "error")
    return {}
  end

  table.sort(dirs)
  table.sort(files)
  vim.list_extend(dirs, files)
  local output = dirs

  -- Normalize paths for comparison
  local normalized_dir = vim.fn.fnamemodify(dir, ":p")
  local normalized_root = vim.fn.fnamemodify(util.project_root, ":p")

  -- If not at project root, prepend parent directory link
  if normalized_dir ~= normalized_root then
    table.insert(output, 1, "../")
  end

  return output
end

scan.run = L.run
return scan
