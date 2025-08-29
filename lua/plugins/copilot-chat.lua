return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      -- model = "claude-sonnet-4",
      model = "gpt-4.1",
      picker = {
        enabled = true,
        ui_select = true,
      }
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
