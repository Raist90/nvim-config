local config = require("lsplorer.config")
local ls = require("lsplorer.ls")
local util = require("lsplorer.util")
local project_name = vim.fn.fnamemodify(util.project_root, ":t")

local autocmd = {}
local A = {}

A.setup = function()
  local group = vim.api.nvim_create_augroup("LsplorerAutoCmds", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    group = group,
    pattern = "*",
    callback = function(args)
      -- Ignore if the buffer is of a special type
      if vim.bo[args.buf].buftype ~= "" then
        return
      end

      local current_buf = args.buf
      local current_buf_name = vim.api.nvim_buf_get_name(current_buf)

      -- Don't process if we're entering the Lsplorer itself
      if current_buf_name:match("Lsplorer$") then
        return
      end

      -- Find the Lsplorer buffer if it exists
      local explorer_buf = nil
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_name(buf):match("Lsplorer$") and vim.api.nvim_buf_is_loaded(buf) then
          explorer_buf = buf
          break
        end
      end

      -- If Lsplorer exists, update it with the current buffer's directory
      if explorer_buf then
        local lsplorer_win = vim.fn.bufwinid(explorer_buf)

        if lsplorer_win ~= -1 then
          vim.wo[lsplorer_win].winbar = "%#LsplorerWinbarInactive#" .. "~/" .. project_name
          -- Dim text and directories when lsplorer becomes inactive
          vim.wo[lsplorer_win].winhighlight = "Normal:LsplorerNormalNC,Directory:LsplorerDirectoryNC"
        end

        if config.opts.follow_active_buffer then
          local dir = vim.fn.fnamemodify(current_buf_name or vim.fn.getcwd(), ":p:h")
          local output = ls.run(dir)

          vim.bo[explorer_buf].modifiable = true
          vim.api.nvim_buf_set_var(explorer_buf, "lsplorer_dir", dir) -- Sync dir
          vim.api.nvim_buf_set_lines(explorer_buf, 0, -1, false, output)
          util.highlights(explorer_buf)
        end

        local current_filename = vim.fn.fnamemodify(current_buf_name, ":t")
        if current_filename ~= "" then
          local lines = vim.api.nvim_buf_get_lines(explorer_buf, 0, -1, false)
          for i, line in ipairs(lines) do
            local line_filename = line:match("^%s*(.+)$")
            if line_filename == current_filename then
              vim.api.nvim_buf_add_highlight(explorer_buf, -1, "LsplorerSelected", i - 1, 0, -1)
              vim.api.nvim_win_set_cursor(lsplorer_win, { i, 0 })
              break
            end
          end
        end

        vim.bo[explorer_buf].modifiable = false
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "WinEnter" }, {
    group = group,
    pattern = "*Lsplorer",
    callback = function()
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].winbar = "%#LsplorerWinbarActive#" .. "~/" .. project_name
      -- Un-dim text and directories when lsplorer becomes active
      vim.wo[win].winhighlight = "Normal:LsplorerNormal,Directory:LsplorerDirectory"
    end,
  })

  vim.api.nvim_create_autocmd({ "WinClosed" }, {
    group = group,
    pattern = "*",
    callback = function()
      -- Use vim.schedule to defer execution (important for WinClosed)
      vim.schedule(function()
        local wins = vim.api.nvim_list_wins()

        -- Check if only 1 window remains
        if #wins == 1 then
          local buf = vim.api.nvim_win_get_buf(wins[1])

          -- If the last window is lsplorer, quit Neovim
          if vim.api.nvim_buf_get_name(buf):match("Lsplorer$") then
            vim.cmd("quit")
          end
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufWipeout" }, {
    group = group,
    pattern = "*Lsplorer",
    callback = function()
      vim.wo.winfixwidth = false
    end,
  })
end

autocmd.setup = A.setup
return autocmd
