-- Enhances netrw file explorer behavior
M = {}

M.load_opts = function()
  vim.g.netrw_banner = 0
  vim.g.netrw_keepdir = 0
  vim.g.netrw_winsize = 15
end

M.neoxp_group = vim.api.nvim_create_augroup("Neoxp", { clear = true })
M.last_dir = nil
M.debounce_timer = nil

M.hijack_netrw = function()
  vim.cmd("silent! autocmd! FileExplorer *")
  vim.cmd("autocmd VimEnter * ++once silent! autocmd! FileExplorer *")
end

M.open_neoxp = function()
  vim.api.nvim_create_autocmd("VimEnter", {
    group = M.neoxp_group,
    callback = function()
      local dir = vim.fn.argv(0)
      if type(dir) == "table" then
        dir = dir[1]
      end

      if vim.fn.argc() == 1 and vim.fn.isdirectory(dir) == 1 then
        local dir_buf = vim.api.nvim_get_current_buf()

        vim.cmd("Lexplore")

        -- Clear the buffer name to make it a clean [No Name] buffer
        vim.api.nvim_buf_set_name(dir_buf, "")
        vim.bo[dir_buf].modified = false
      end
    end,
  })
end

M.refresh_neoxp = function()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = M.neoxp_group,
    callback = function(args)
      if args.event == "BufEnter" then
        print("BufEnter: " .. vim.api.nvim_buf_get_name(args.buf))
      end

      -- Clear any pending debounce timer
      if M.debounce_timer then
        vim.fn.timer_stop(M.debounce_timer)
      end

      -- Debounce: wait 100ms before executing
      M.debounce_timer = vim.fn.timer_start(100, function()
        local buf = args.buf
        local buftype = vim.bo[buf].buftype
        local filetype = vim.bo[buf].filetype

        -- Skip special buffers
        if buftype ~= "" and buftype ~= "acwrite" then
          return
        end

        -- Skip netrw itself to prevent loops
        if filetype == "netrw" then
          return
        end

        -- Skip if no valid file path
        local filepath = vim.api.nvim_buf_get_name(buf)
        if filepath == "" or not vim.fn.filereadable(filepath) == 1 then
          return
        end

        -- Get the directory of the current buffer
        local dir = vim.fn.fnamemodify(filepath, ":p:h")

        -- Skip if directory hasn't changed
        if dir == M.last_dir then
          return
        end
        M.last_dir = dir

        -- Check if Lexplore is open by looking for netrw windows
        local netrw_win = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local win_buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[win_buf].filetype == "netrw" then
            netrw_win = win
            break
          end
        end

        -- Only refresh if Lexplore is actually open
        if netrw_win then
          vim.cmd("Lexplore " .. vim.fn.fnameescape(dir))
          vim.cmd("Lexplore " .. vim.fn.fnameescape(dir)) -- Toggle back open
        end
      end)
    end,
  })
end

M.load_autocommands = function()
  M.hijack_netrw()
  M.open_neoxp()
  M.refresh_neoxp()
end

local function setup()
  M.load_opts()
  M.load_autocommands()
end

M.setup = setup

return M
