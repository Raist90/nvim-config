vim.g.mapleader = " " -- Set leader key before Lazy
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

-- Move to window using the <ctrl> hjkl keys
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Window management
keymap("n", "<leader>wv", "<C-W>v", { desc = "Split Window Right", remap = true })
keymap("n", "<leader>ws", "<C-W>s", { desc = "Split Window Down", remap = true })
keymap("n", "<leader>ww", "<C-W>w", { desc = "Next Window", remap = true })

-- Package management
keymap("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Mason" })
keymap("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Git
keymap("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git Blame Line" })
keymap("n", "<leader>gB", "<cmd>Gitsigns blame<cr>", { desc = "Git Blame" })

-- Search and replace in quickfix
-- We can use Telescope live_grep and Ctrl Q to send results to quickfix
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<leader>qr", function()
      local srcVal, rplVal

      -- Prompt for the source value
      vim.ui.input({ prompt = "Enter source value: " }, function(input)
        if input then
          srcVal = input

          -- Prompt for the replace value after source value is entered
          vim.ui.input({ prompt = "Enter replace value: " }, function(input2)
            if input2 then
              rplVal = input2

              -- Perform the replacement using :cdo and save the changes
              vim.cmd("cdo s/" .. srcVal .. "/" .. rplVal .. "/g | update")
            else
              print("Replace value was not provided.")
            end
          end)
        else
          print("Source value was not provided.")
        end
      end)
    end, { desc = "Search and Replace", buffer = true }) -- Set the keymap only for the quickfix buffer
  end,
})
-- Open the quickfix list
vim.keymap.set("n", "<leader>qo", function()
  vim.cmd("copen")
end, { desc = "Open Quickfix List" })

-- Delete (clear) the quickfix list
vim.keymap.set("n", "<leader>qc", function()
  vim.fn.setqflist({})
  vim.cmd("cclose")
end, { desc = "Clear Quickfix List" })

-- Toggle the notification history
vim.keymap.set("n", "<leader>nh", function()
  require("snacks").notifier.show_history()
end, { desc = "Show Notification History" })

-- Toggle the terminal
vim.keymap.set("n", "<leader>tt", function()
  require("snacks").terminal.toggle()
end
)

-- Toggle Zen Mode
vim.keymap.set("n", "<leader>Z", function()
  require("snacks").zen()
end, { desc = "Toggle Zen Mode" })

-- Copilot chat keymaps
vim.keymap.set("n", "<leader>Co", "<cmd>CopilotChatOpen<cr>", { desc = "Copilot Chat Prompts" })
vim.keymap.set("n", "<leader>Cc", "<cmd>CopilotChatClose<cr>", { desc = "Copilot Chat Close" })

-- Open file history via LazyGit
vim.keymap.set("n", "<leader>gh", "<cmd>LazyGitFilterCurrentFile<cr>", { desc = "Open File History" })
