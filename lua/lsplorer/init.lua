-- Lsplorer
-- TODO: Refactor this mess
local E = {}

function E.handle_enter()
  local buf = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_get_current_line()

  -- Skip empty lines
  if line == "" or line:match("^%s*$") then
    return
  end

  -- Extract filename from "icon filename" format
  -- Pattern: icon (non-whitespace) + space(s) + filename
  -- TODO: Let's also support ls -1 in config and make this optional
  local filename = line:match("^%S+%s+(.+)$")

  -- TODO: maybe extract this into a util
  if not filename or filename == "." or filename == ".." then
    return
  end

  local explorer_dir = vim.b.lsplorer_dir
  local full_path = explorer_dir .. "/" .. filename

  -- Check if it's a directory
  if vim.fn.isdirectory(full_path) == 1 then
    -- Navigate into directory
    vim.b.lsplorer_dir = full_path
    local output = vim.fn.systemlist("/opt/homebrew/bin/eza -1 --icons=always " .. vim.fn.shellescape(full_path))

    -- Update Lsplorer buffer
    vim.bo[buf].readonly = false
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    vim.bo[buf].readonly = true
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

function E.open_lsplorer()
  -- Get directory from current buffer BEFORE creating scratch buffer
  local buf_path = vim.api.nvim_buf_get_name(0)
  local dir = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":p:h") or vim.loop.cwd()

  vim.cmd("topleft vertical 30new")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.buflisted = false
  vim.bo.filetype = "scratch"

  -- Store the directory in buffer variable so autocmd can use it
  vim.b.lsplorer_dir = dir

  local output = vim.fn.systemlist("/opt/homebrew/bin/eza -1 --icons=always " .. vim.fn.shellescape(dir))
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
  vim.api.nvim_buf_set_name(0, "Lsplorer")
  vim.bo.readonly = true
  vim.wo.winfixwidth = true
  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.cmd("wincmd =")

  -- Set up Enter key to open files/navigate directories
  vim.keymap.set("n", "<CR>", E.handle_enter, { buffer = 0, noremap = true, silent = true })
end

vim.api.nvim_create_user_command("Lsplorer", function()
  E.open_lsplorer()
end, {})

E.is_open = function()
  local explorer_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf):match("Lsplorer$") and vim.api.nvim_buf_is_loaded(buf) then
      explorer_buf = buf
      break
    end
  end
  return explorer_buf ~= nil
end

E.close_lsplorer = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local win_buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_name(win_buf):match("Lsplorer$") then
      vim.api.nvim_win_close(win, true)
      break
    end
  end
end

E.toggle = function()
  if E.is_open() then
    -- Close the Lsplorer buffer
    E.close_lsplorer()
  else
    -- Open Lsplorer
    E.open_lsplorer()
  end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  pattern = "*",
  callback = function(args)
    -- Ignore if the buffer is of a special type
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    local current_buf = args.buf
    local current_buf_name = vim.api.nvim_buf_get_name(current_buf)
    -- print("triggered from: " .. current_buf_name)

    -- -- Don't process if we're entering the Lsplorer itself
    if current_buf_name:match("Lsplorer$") then
      -- print("entered Lsplorer, skipping update")
      return
    end

    --
    -- -- Find the Lsplorer buffer if it exists
    local explorer_buf = nil
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_name(buf):match("Lsplorer$") and vim.api.nvim_buf_is_loaded(buf) then
        explorer_buf = buf
        -- print("found Lsplorer buffer: " .. vim.api.nvim_buf_get_name(buf))
        break
      end
    end
    --
    -- -- If Lsplorer exists, update it with the current buffer's directory
    if explorer_buf then
      local dir = current_buf_name ~= "" and vim.fn.fnamemodify(current_buf_name, ":p:h") or vim.loop.cwd()
      local lsplorer_dir = vim.api.nvim_buf_get_var(explorer_buf, "lsplorer_dir")
      -- print(dir, lsplorer_dir)

      if dir == lsplorer_dir then
        return
      end

      local output = vim.fn.systemlist("/opt/homebrew/bin/eza -1 --icons=always " .. vim.fn.shellescape(dir))
      vim.bo[explorer_buf].readonly = false
      vim.api.nvim_buf_set_var(explorer_buf, "lsplorer_dir", dir) -- Sync dir
      vim.api.nvim_buf_set_lines(explorer_buf, 0, -1, false, output)
      vim.bo[explorer_buf].readonly = true
    end
  end,
})

return E
