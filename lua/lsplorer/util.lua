local U = {}

-- Track project root (updated when user changes directory)
local project_root = vim.loop.cwd()

local function eza_output(dir)
  return vim.fn.systemlist(
    -- "/opt/homebrew/bin/eza -1 --icons=always --group-directories-first " .. vim.fn.shellescape(dir)
    "/opt/homebrew/bin/eza -1 -F=always --group-directories-first " .. vim.fn.shellescape(dir)
  )
end

local function is_valid_filename(f)
  return f and f ~= "." and f ~= ""
  -- Allow ".." for parent directory navigation
end

local function update_project_root()
  project_root = vim.loop.cwd()
end

local function eza_output_with_parent(dir)
  local output = eza_output(dir)

  -- Normalize paths for comparison
  local normalized_dir = vim.fn.fnamemodify(dir, ":p")
  local normalized_root = vim.fn.fnamemodify(project_root, ":p")

  -- If not at project root, prepend parent directory link
  if normalized_dir ~= normalized_root then
    table.insert(output, 1, "../")
  end

  return output
end

local function setup_highlights(buf)
  vim.api.nvim_buf_call(buf, function()
    vim.cmd([[
      syntax clear
      syntax match LsplorerDirectory "^.*/$"
      hi def link LsplorerDirectory Directory
    ]])
  end)
end

-- Set up winbar with project name for lsplorer window
local function setup_winbar(win, root)
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
  -- TODO: use actual_curwin and make it blue when active
  vim.wo[win].winbar = "%#LsplorerWinbarActive#" .. "~/" .. project_name
end

U.eza_output = eza_output
U.eza_output_with_parent = eza_output_with_parent
U.is_valid_filename = is_valid_filename
U.setup_highlights = setup_highlights
U.setup_winbar = setup_winbar
U.update_project_root = update_project_root
U.project_root = project_root

return U
