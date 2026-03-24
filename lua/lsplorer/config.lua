local config = {}

---@class LsplorerBufferOpts
---@field side "topleft"|"botright"
---@field width number

---@class LsplorerOpts
---@field ui LsplorerBufferOpts
---@field follow_active_buffer boolean

---@type LsplorerOpts
local default_opts = {
  follow_active_buffer = true, -- Automatically update the explorer when changing buffers
  ui = {
    side = "topleft",
    width = 30,
  },
}

config.opts = default_opts
return config
