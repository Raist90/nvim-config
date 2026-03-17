local util = {}
local U = {}

-- Track project root (updated when user changes directory)
U.project_root = vim.fn.getcwd()

function U.ls_output(dir)
  if vim.fn.executable("ls") == 1 then
    local cmd = string.format("ls -1 %s", vim.fn.shellescape(dir))
    local entries = vim.fn.systemlist(cmd)
    local dirs, files = {}, {}
    for _, entry in ipairs(entries) do
      if vim.fn.isdirectory(dir .. "/" .. entry) == 1 then
        table.insert(dirs, entry .. "/")
      else
        table.insert(files, entry)
      end
    end
    vim.list_extend(dirs, files)
    return dirs
  else
    return {}
  end
end

function U.is_valid_filename(f)
  return f and f ~= "." and f ~= ""
  -- Allow ".." for parent directory navigation
end

function U.update_project_root()
  U.project_root = vim.fn.getcwd()
end

function U.ls_output_with_parent(dir)
  local output = U.ls_output(dir)

  -- Normalize paths for comparison
  local normalized_dir = vim.fn.fnamemodify(dir, ":p")
  local normalized_root = vim.fn.fnamemodify(U.project_root, ":p")

  -- If not at project root, prepend parent directory link
  if normalized_dir ~= normalized_root then
    table.insert(output, 1, "../")
  end

  return output
end

function U.setup_highlights(buf)
  vim.api.nvim_buf_call(buf, function()
    vim.cmd([[
      syntax clear
      syntax match Directory "^.*/$"
    ]])
  end)
end

-- Set up winbar with project name for lsplorer window
function U.setup_winbar(win, root)
  -- Get project name (last component of root path)
  local project_name = vim.fn.fnamemodify(root, ":t")

  -- Get window width for truncation
  local win_width = vim.api.nvim_win_get_width(win)

  -- Truncate with ... if project name is longer than window width
  if #project_name > win_width then
    local max_len = win_width - 3 -- Reserve 3 chars for "..."
    if max_len > 0 then
      project_name = project_name:sub(1, max_len) .. "..."
    else
      project_name = "..."
    end
  end

  -- Set window-local winbar with custom highlight
  vim.wo[win].winbar = "%#LsplorerWinbarActive#" .. "~/" .. project_name
end

util.ls_output = U.ls_output
util.ls_output_with_parent = U.ls_output_with_parent
util.is_valid_filename = U.is_valid_filename
util.setup_highlights = U.setup_highlights
util.setup_winbar = U.setup_winbar
util.update_project_root = U.update_project_root
util.project_root = U.project_root

return util
