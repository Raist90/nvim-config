local buffers = require("lsplorer.buffers")
local git = require("lsplorer.git")
local ui = require("lsplorer.ui")
local util = require("lsplorer.util")

local function open_parent_dir()
  local parent = vim.fn.fnamemodify(vim.b.lsplorer_dir, ":h")
  if parent ~= vim.b.lsplorer_dir then
    vim.b.lsplorer_dir = parent
    ui.refresh_lsplorer(vim.b.lsplorer_dir, vim.api.nvim_get_current_buf())
  end
end

---@param dir string
local function open_dir(dir)
  vim.b.lsplorer_dir = dir
  ui.refresh_lsplorer(vim.b.lsplorer_dir, vim.api.nvim_get_current_buf())
end

---@param file string
local function open_file(file)
  local currwin = vim.api.nvim_get_current_win()
  vim.cmd("wincmd l") -- Try to move to window on the right

  -- If we're still in the same window, no window exists to the right
  if vim.api.nvim_get_current_win() == currwin then
    -- Create a new vertical split
    vim.cmd("vsplit")
  end

  file = git.strip_status(file)
  vim.cmd("edit " .. vim.fn.fnameescape(file))
end

local A = {}

function A.open_entry()
  local currline = vim.api.nvim_get_current_line()

  -- Skip empty lines
  if currline == "" or currline:match("^%s*$") then
    return
  end

  local normalized_path = currline:gsub("/$", "")
  if not util.is_valid_selection(normalized_path) then
    util.log("invalid filename selected: " .. normalized_path, "error")
    return
  end
  if normalized_path == ".." then
    open_parent_dir()
    return
  end

  local full_path = vim.b.lsplorer_dir .. "/" .. normalized_path
  if vim.fn.isdirectory(full_path) == 1 then
    open_dir(full_path)
  else
    open_file(full_path)
  end
end

function A.add_entry()
  local buf = vim.api.nvim_get_current_buf()
  local dir = vim.b.lsplorer_dir

  -- Prompt for filename
  vim.ui.input({ prompt = "New file name: " }, function(filename)
    if not filename or filename == "" then
      return
    end

    -- Reject parent directory navigation for safety
    if filename:match("%.%./") or filename:match("^%.%.") then
      util.log("cannot create files in parent directory: " .. filename, "error")
      return
    end

    local full_path = dir .. "/" .. filename

    -- Check if already exists
    if vim.fn.filereadable(full_path) == 1 or vim.fn.isdirectory(full_path) == 1 then
      util.log("already exists: " .. filename, "error")
      return
    end

    -- Create directory if ends with /
    if filename:match("/$") then
      local dir_path = full_path:gsub("/$", "")
      local success, err = pcall(vim.fn.mkdir, dir_path, "p")
      if not success then
        util.log("failed to create directory: " .. tostring(err), "error")
        return
      end
      util.log("created directory: " .. filename, "info")
    else
      -- Create file
      local f, err = io.open(full_path, "w")
      if not f then
        util.log("failed to create file: " .. tostring(err), "error")
        return
      end
      f:close()
      util.log("created file: " .. filename, "info")
    end

    -- Refresh lsplorer to show the new file/directory
    ui.refresh_lsplorer(dir, buf)
  end)
end

function A.rename_entry()
  local buf = vim.api.nvim_get_current_buf()
  local ls_dir = vim.b.lsplorer_dir

  local currline = vim.api.nvim_get_current_line()
  currline = currline:gsub("/$", "")
  if currline == "" then
    util.log("no file selected for renaming", "error")
  end

  currline = git.strip_status(currline)
  vim.ui.input({ default = currline, prompt = "Rename to: " }, function(new_name)
    if not new_name or new_name == "" then
      return
    end

    -- Reject parent directory navigation for safety
    if new_name:match("%.%./") or new_name:match("^%.%.") then
      util.log("cannot rename to parent directory: " .. new_name, "error")
      return
    end

    local prev_name = currline
    local prev_path = ls_dir .. "/" .. prev_name
    local new_path = ls_dir .. "/" .. new_name
    -- Check if new name already exists
    if vim.fn.filereadable(new_path) == 1 or vim.fn.isdirectory(new_path) == 1 then
      util.log("already exists: " .. new_name, "error")
      return
    end

    -- Perform rename
    local success, err = pcall(vim.fn.rename, prev_path, new_path)
    if not success then
      util.log("failed to rename: " .. tostring(err), "error")
      return
    end

    util.log("renamed to: " .. new_name, "info")

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local win_buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_get_name(win_buf):match(prev_name) then
        print("Closed window with renamed file open", vim.api.nvim_buf_get_name(win_buf))
        vim.api.nvim_buf_set_name(win_buf, new_path)

        vim.api.nvim_buf_call(win_buf, function()
          vim.cmd("silent! write! | edit")
        end)
        break
      end
    end

    -- Refresh lsplorer to show the renamed file/directory
    ui.refresh_lsplorer(ls_dir, buf)
  end)
end

function A.delete_entry()
  local buf = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_get_current_line()

  if util.is_empty_string(filename) then
    util.log("no file selected for deletion", "error")
    return
  end

  filename = filename:gsub("/$", "")
  filename = git.strip_status(filename)
  if filename == ".." then
    util.log("cannot delete parent directory link: " .. filename, "error")
    return
  end

  if not util.is_valid_selection(filename) then
    util.log("invalid filename selected: " .. filename, "error")
    return
  end

  local current_dir = vim.b.lsplorer_dir
  local full_path = current_dir .. "/" .. filename

  -- Check if file/directory exists
  local exists = vim.fn.filereadable(full_path) == 1 or vim.fn.isdirectory(full_path) == 1
  if not exists then
    util.log("file not found: " .. filename, "error")
    return
  end

  local is_dir = vim.fn.isdirectory(full_path) == 1

  -- Prevent deleting the current lsplorer directory
  local normalized_path = vim.fn.fnamemodify(full_path, ":p")
  local normalized_current = vim.fn.fnamemodify(current_dir, ":p")
  if is_dir and normalized_path == normalized_current then
    util.log("cannot delete current directory: " .. filename, "error")
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
      util.log("failed to delete: " .. tostring(err), "error")
      return
    end

    if err ~= 0 then
      util.log("failed to delete: " .. filename, "error")
      return
    end

    -- Success feedback and refresh
    util.log("deleted: " .. display_name, "info")

    -- Wipe any open buffers for deleted file/directory (silent)
    buffers.wipe_buffers_for_path(full_path, is_dir)

    ui.refresh_lsplorer(current_dir, buf)
  end)
end

return A
