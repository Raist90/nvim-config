local eza_output_with_parent = require("lsplorer.util").eza_output_with_parent
local project_name = vim.fn.fnamemodify(require("lsplorer.util").project_root, ":t")

A = {}

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
        local lsplorer_win = vim.fn.bufwinid(explorer_buf)

        if lsplorer_win ~= -1 then
          vim.wo[lsplorer_win].winbar = "%#LsplorerWinbarInactive#" .. "~/" .. project_name
          -- Dim text and directories when lsplorer becomes inactive
          vim.wo[lsplorer_win].winhighlight = "Normal:LsplorerNormalNC,Directory:LsplorerDirectoryNC"
        end

        local dir = vim.fn.fnamemodify(current_buf_name or vim.fn.getcwd(), ":p:h")
        -- TODO: Carefully think about this
        -- local lsplorer_dir = vim.api.nvim_buf_get_var(explorer_buf, "lsplorer_dir")
        -- print(dir, lsplorer_dir)

        -- if dir == lsplorer_dir then
        --   return
        -- end

        local output = eza_output_with_parent(dir)

        vim.bo[explorer_buf].readonly = false
        vim.api.nvim_buf_set_var(explorer_buf, "lsplorer_dir", dir) -- Sync dir
        vim.api.nvim_buf_set_lines(explorer_buf, 0, -1, false, output)
        require("lsplorer.util").setup_highlights(explorer_buf)
        vim.bo[explorer_buf].readonly = true
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "WinEnter" }, {
    group = group,
    pattern = "*Lsplorer", -- Match buffers ending in "Lsplorer"
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
end

return A
