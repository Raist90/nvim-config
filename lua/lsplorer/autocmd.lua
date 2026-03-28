local config = require("lsplorer.config")
local git = require("lsplorer.git")
local ls = require("lsplorer.ls")
local ui = require("lsplorer.ui")
local util = require("lsplorer.util")
local project_name = vim.fn.fnamemodify(util.project_root, ":t")

local autocmd = {}
local A = {}

-- TODO: maybe make this one a util
local function get_buffer_filename(buf)
  local full_path = vim.api.nvim_buf_get_name(buf)
  return vim.fn.fnamemodify(full_path, ":t")
end

local function find_filename_line(lines, filename)
  return util.find(lines, function(line)
    line = line:match("^%s*(.+)$") -- Trim leading whitespace
    line = git.strip_status(line)
    return line == filename
  end)
end

local function highlight_selection(lsplorer_buf, buf)
  local filename = get_buffer_filename(buf)
  if util.is_empty_string(filename) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(lsplorer_buf, 0, -1, false)
  local _, line_index = find_filename_line(lines, filename)
  if not line_index then
    return
  end
  vim.api.nvim_buf_add_highlight(lsplorer_buf, -1, "LsplorerSelected", line_index - 1, 0, #filename)

  local lsplorer_win = vim.fn.bufwinid(lsplorer_buf)
  if lsplorer_win == -1 then
    return
  end
  vim.api.nvim_win_set_cursor(lsplorer_win, { line_index, 0 })
end

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

      local currbuf = args.buf
      local currbuf_name = vim.api.nvim_buf_get_name(currbuf)
      -- Don't process if we're entering the Lsplorer itself
      if currbuf_name:match("Lsplorer$") then
        return
      end

      local lsplorer_buf = util.find_lsplorer_buf()
      -- If Lsplorer exists, update it with the current buffer's directory
      if lsplorer_buf then
        local lsplorer_win = vim.fn.bufwinid(lsplorer_buf)
        if lsplorer_win ~= -1 then
          vim.wo[lsplorer_win].winbar = "%#LsplorerWinbarInactive#" .. "~/" .. project_name
          -- Dim text and directories when lsplorer becomes inactive
          vim.wo[lsplorer_win].winhighlight = "Normal:LsplorerNormalNC,Directory:LsplorerDirectoryNC"
        end

        if config.opts.follow_active_buffer then
          local dir = vim.fn.fnamemodify(currbuf_name or vim.fn.getcwd(), ":p:h")
          local output = ls.run(dir)

          vim.bo[lsplorer_buf].modifiable = true
          vim.api.nvim_buf_set_var(lsplorer_buf, "lsplorer_dir", dir) -- Sync dir
          vim.api.nvim_buf_set_lines(lsplorer_buf, 0, -1, false, output)
          util.highlights(lsplorer_buf)
        end

        highlight_selection(lsplorer_buf, currbuf)

        vim.bo[lsplorer_buf].modifiable = false
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

  -- Reset winfixwidth when lsplorer buffer is replaced to allow resizing the new one
  vim.api.nvim_create_autocmd({ "BufWipeout" }, {
    group = group,
    pattern = "*Lsplorer",
    callback = function()
      vim.wo.winfixwidth = false
    end,
  })

  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = group,
    pattern = "*",
    callback = function()
      local explorer_buf = util.find_lsplorer_buf()
      if explorer_buf then
        -- refresh lsplorer with current dir and buf in order to update git status
        local dir = vim.api.nvim_buf_get_var(explorer_buf, "lsplorer_dir")
        ui.refresh_lsplorer(dir, explorer_buf)

        highlight_selection(explorer_buf, 0)
      end
    end,
  })
end

autocmd.setup = A.setup
return autocmd
