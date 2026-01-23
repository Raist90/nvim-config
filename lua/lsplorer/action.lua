local eza_output_with_parent = require("lsplorer.util").eza_output_with_parent
local is_valid_filename = require("lsplorer.util").is_valid_filename

local A = {}

local refresh_lsplorer = function(path, buf)
  local output = eza_output_with_parent(path)

  -- Update Lsplorer buffer
  vim.bo[buf].readonly = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
  require("lsplorer.util").setup_highlights(buf)
  vim.bo[buf].readonly = true
end

local function handle_enter()
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_get_current_line()

  -- Skip empty lines
  if line == "" or line:match("^%s*$") then
    return
  end

  -- Extract filename from "icon filename" format
  -- Pattern: icon (non-whitespace) + space(s) + filename
  -- TODO: Let's also support ls -1 in config and make this optional
  -- local filename = line:match("^%S+%s+(.+)$")
  -- Strip trailing slash for directories (added by eza -F flag)
  local filename = line:gsub("/$", "")

  if not is_valid_filename(filename) then
    vim.api.nvim_echo({ { "Lsplorer: Invalid filename selected.", "ErrorMsg" } }, false, {})
    return
  end

  -- Handle parent directory navigation
  if filename == ".." then
    local parent = vim.fn.fnamemodify(vim.b.lsplorer_dir, ":h")
    -- Only navigate if parent != current (prevents navigation at/above root)
    -- TODO: Add error handling if parent directory is not accessible
    if parent ~= vim.b.lsplorer_dir then
      vim.b.lsplorer_dir = parent
      A.refresh_lsplorer(vim.b.lsplorer_dir, buf)
    end
    return
  end

  local full_path = vim.b.lsplorer_dir .. "/" .. filename

  -- Check if it's a directory
  -- TODO: Should I update the lsplorer_dir with an autocmd instead?
  if vim.fn.isdirectory(full_path) == 1 then
    -- Navigate into directory
    vim.b.lsplorer_dir = full_path

    A.refresh_lsplorer(vim.b.lsplorer_dir, buf)
  else
    -- It's a file - open in window to the right
    local current_win = vim.fn.winnr()
    vim.cmd("wincmd l") -- Try to move to window on the right

    -- If we're still in the same window, no window exists to the right
    if vim.fn.winnr() == current_win then
      -- Create a new vertical split
      vim.cmd("vsplit")
    end

    -- Open the file
    vim.cmd("edit " .. vim.fn.fnameescape(full_path))

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local win_buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_get_name(win_buf):match("Lsplorer$") then
        vim.api.nvim_win_set_width(win, 30)
        break
      end
    end
  end
end

local function rename_file()
  local buf = vim.api.nvim_get_current_buf()
  local dir = vim.b.lsplorer_dir

  vim.ui.input({ default = vim.api.nvim_get_current_line():gsub("/$", ""), prompt = "Rename to: " }, function(new_name)
    if not new_name or new_name == "" then
      return
    end

    -- Reject parent directory navigation for safety
    if new_name:match("%.%./") or new_name:match("^%.%.") then
      vim.notify("Cannot rename to parent directory", vim.log.levels.ERROR)
      return
    end

    local line = vim.api.nvim_get_current_line()
    local old_name = line:gsub("/$", "")
    local old_path = dir .. "/" .. old_name
    local new_path = dir .. "/" .. new_name

    -- Check if new name already exists
    if vim.fn.filereadable(new_path) == 1 or vim.fn.isdirectory(new_path) == 1 then
      vim.notify("Already exists: " .. new_name, vim.log.levels.ERROR)
      return
    end

    -- Perform rename
    local success, err = pcall(vim.fn.rename, old_path, new_path)
    if not success then
      vim.notify("Failed to rename: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    vim.notify("Renamed to: " .. new_name, vim.log.levels.INFO)

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local win_buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_get_name(win_buf):match(old_name) then
        -- vim.api.nvim_win_close(win, true)
        print("Closed window with renamed file open", vim.api.nvim_buf_get_name(win_buf))
        vim.api.nvim_buf_set_name(win_buf, new_path)

        vim.api.nvim_buf_call(win_buf, function()
          vim.cmd("silent! write! | edit")
        end)
        break
      end
    end

    -- Refresh lsplorer to show the renamed file/directory
    A.refresh_lsplorer(dir, buf)
  end)
end

local function add_file()
  local buf = vim.api.nvim_get_current_buf()
  local dir = vim.b.lsplorer_dir

  -- Prompt for filename
  vim.ui.input({ prompt = "New file name: " }, function(filename)
    if not filename or filename == "" then
      return
    end

    -- Reject parent directory navigation for safety
    if filename:match("%.%./") or filename:match("^%.%.") then
      vim.notify("Cannot create files in parent directory", vim.log.levels.ERROR)
      return
    end

    local full_path = dir .. "/" .. filename

    -- Check if already exists
    if vim.fn.filereadable(full_path) == 1 or vim.fn.isdirectory(full_path) == 1 then
      vim.notify("Already exists: " .. filename, vim.log.levels.ERROR)
      return
    end

    -- Create directory if ends with /
    if filename:match("/$") then
      local dir_path = full_path:gsub("/$", "")
      local success, err = pcall(vim.fn.mkdir, dir_path, "p")
      if not success then
        vim.notify("Failed to create directory: " .. tostring(err), vim.log.levels.ERROR)
        return
      end
      vim.notify("Created directory: " .. filename, vim.log.levels.INFO)
    else
      -- Create file
      local f, err = io.open(full_path, "w")
      if not f then
        vim.notify("Failed to create file: " .. tostring(err), vim.log.levels.ERROR)
        return
      end
      f:close()
      vim.notify("Created file: " .. filename, vim.log.levels.INFO)
    end

    -- Refresh lsplorer to show the new file/directory
    A.refresh_lsplorer(dir, buf)
  end)
end

A.handle_enter = handle_enter
A.refresh_lsplorer = refresh_lsplorer
A.add_file = add_file
A.rename_file = rename_file

return A
