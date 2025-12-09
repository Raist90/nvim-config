-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  desc = "Highlight selection on yank",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Open help files in a vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  command = "wincmd L",
})

-- Disable auto commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("No auto comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Disable copilot suggestion when BlinkCmp menu is open
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    require("copilot.suggestion").dismiss()
    vim.b.copilot_suggestion_hidden = true
  end,
})

-- Re-enable copilot suggestion when BlinkCmp menu is closed
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})

-- Auto-refresh Lexplore when changing buffers
local lexplore_group = vim.api.nvim_create_augroup("Neoxplorer", { clear = true })
local last_dir = nil
local debounce_timer = nil

vim.cmd("silent! autocmd! FileExplorer *")
vim.cmd("autocmd VimEnter * ++once silent! autocmd! FileExplorer *")

vim.api.nvim_create_autocmd("VimEnter", {
  group = lexplore_group,
  callback = function()
    local dir = vim.fn.argv(0)
    if type(dir) == "table" then
      dir = dir[1]
    end

    if vim.fn.argc() == 1 and vim.fn.isdirectory(dir) == 1 then
      vim.cmd("Lexplore")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  group = lexplore_group,
  callback = function(args)
    -- Clear any pending debounce timer
    if debounce_timer then
      vim.fn.timer_stop(debounce_timer)
    end

    -- Debounce: wait 100ms before executing
    debounce_timer = vim.fn.timer_start(100, function()
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
      if dir == last_dir then
        return
      end
      last_dir = dir

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
