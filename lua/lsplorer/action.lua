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

local function open_file()
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

-- Helper function to wipe buffers matching a path (for deleted files/directories)
-- Uses snacks.nvim's approach: find replacement buffer first, then switch windows, then wipe
local function wipe_buffers_for_path(path, is_dir)
  -- First pass: collect all buffers that need to be wiped
  local buffers_to_wipe = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local buf_name = vim.api.nvim_buf_get_name(buf)

      -- Skip empty buffer names (like [No Name] buffers)
      if buf_name == "" then
        goto continue
      end

      local should_wipe = false
      if is_dir then
        -- For directories: wipe if buffer is inside this directory
        local normalized_buf = vim.fn.fnamemodify(buf_name, ":p")
        local normalized_dir = vim.fn.fnamemodify(path, ":p")

        -- Ensure directory path ends with separator to prevent partial matches
        -- e.g., /project/src/ should not match /project/src-backup/
        if not normalized_dir:match("/$") then
          normalized_dir = normalized_dir .. "/"
        end

        should_wipe = normalized_buf:sub(1, #normalized_dir) == normalized_dir
      else
        -- For files: exact match only
        local normalized_buf = vim.fn.fnamemodify(buf_name, ":p")
        local normalized_file = vim.fn.fnamemodify(path, ":p")
        should_wipe = normalized_buf == normalized_file
      end

      if should_wipe then
        table.insert(buffers_to_wipe, buf)
      end

      ::continue::
    end
  end

  -- Second pass: wipe each buffer using snacks.nvim's non-destructive approach
  for _, buf in ipairs(buffers_to_wipe) do
    -- Get the most recently used listed buffer (excluding the one being deleted)
    local info = vim.fn.getbufinfo({ buflisted = 1 })
    info = vim.tbl_filter(function(b)
      return b.bufnr ~= buf
    end, info)
    table.sort(info, function(a, b)
      return a.lastused > b.lastused
    end)

    -- Use most recent buffer, or create a new empty one if none exist
    local new_buf = info[1] and info[1].bufnr or vim.api.nvim_create_buf(true, false)

    -- Replace buffer in all windows showing it
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      local win_buf = new_buf
      -- Try using alternate buffer for each window
      vim.api.nvim_win_call(win, function()
        local alt = vim.fn.bufnr("#")
        win_buf = alt >= 0 and alt ~= buf and vim.bo[alt].buflisted and alt or win_buf
      end)
      vim.api.nvim_win_set_buf(win, win_buf)
    end

    -- Now safe to wipe - buffer not displayed anywhere
    pcall(vim.cmd, "bwipeout! " .. buf)
  end
end

local function delete_file()
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_get_current_line()

  -- Skip empty lines
  if line == "" or line:match("^%s*$") then
    return
  end

  -- Extract filename (strip trailing slash for directories)
  local filename = line:gsub("/$", "")

  -- Don't allow deleting ../
  if filename == ".." then
    vim.notify("Cannot delete parent directory link", vim.log.levels.ERROR)
    return
  end

  -- Validate filename
  if not is_valid_filename(filename) then
    vim.notify("Invalid filename", vim.log.levels.ERROR)
    return
  end

  local current_dir = vim.b.lsplorer_dir
  local full_path = current_dir .. "/" .. filename

  -- Check if file/directory exists
  local exists = vim.fn.filereadable(full_path) == 1 or vim.fn.isdirectory(full_path) == 1
  if not exists then
    vim.notify("File not found: " .. filename, vim.log.levels.ERROR)
    return
  end

  local is_dir = vim.fn.isdirectory(full_path) == 1

  -- Prevent deleting the current lsplorer directory
  local normalized_path = vim.fn.fnamemodify(full_path, ":p")
  local normalized_current = vim.fn.fnamemodify(current_dir, ":p")
  if is_dir and normalized_path == normalized_current then
    vim.notify("Cannot delete current directory", vim.log.levels.ERROR)
    return
  end

  -- Show confirmation prompt
  local prompt_type = is_dir and "directory" or "file"
  local display_name = is_dir and (filename .. "/") or filename

  vim.ui.input({ prompt = "Delete " .. prompt_type .. " '" .. display_name .. "'? (y/n): " }, function(input)
    -- Check confirmation
    if not input or (input ~= "y" and input ~= "Y") then
      return -- User cancelled
    end

    -- Attempt deletion
    local success, err
    if is_dir then
      -- Recursive force delete for directories
      success, err = pcall(vim.fn.delete, full_path, "rf")
    else
      -- Normal delete for files
      success, err = pcall(vim.fn.delete, full_path)
    end

    -- Handle result
    if not success then
      vim.notify("Failed to delete: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    if err ~= 0 then
      vim.notify("Failed to delete: " .. filename, vim.log.levels.ERROR)
      return
    end

    -- Success feedback and refresh
    vim.notify("Deleted: " .. display_name, vim.log.levels.INFO)

    -- Wipe any open buffers for deleted file/directory (silent)
    wipe_buffers_for_path(full_path, is_dir)

    A.refresh_lsplorer(current_dir, buf)
  end)
end

A.open_file = open_file
A.refresh_lsplorer = refresh_lsplorer
A.add_file = add_file
A.rename_file = rename_file
A.delete_file = delete_file

return A
