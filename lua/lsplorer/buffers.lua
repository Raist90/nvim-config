local buffers = {}
local B = {}

-- Helper function to wipe buffers matching a path (for deleted files/directories)
-- Uses snacks.nvim's approach: find replacement buffer first, then switch windows, then wipe
function B.wipe_buffers_for_path(path, is_dir)
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

buffers.wipe_buffers_for_path = B.wipe_buffers_for_path
return buffers
