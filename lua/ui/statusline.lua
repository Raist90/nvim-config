local pad_string = require("util").pad_string

Statusline = {}

local highlight = function(hl)
  return string.format("%%#%s#", hl)
end

local function git_branch_component()
  if not vim.b.gitsigns_head then
    return ""
  end

  local str
  local head = vim.b.gitsigns_head or "-"
  local status = vim.b.gitsigns_status or ""
  if status ~= "" then
    str = string.format("%s %s", head, status)
  else
    str = head
  end

  return string.format("%s%s", highlight("StatuslineGit"), str)
end

local function filepath_component()
  local filepath = vim.fn.expand("%:~:.")
  local parts = {}
  for part in string.gmatch(filepath, "[^/]+") do
    table.insert(parts, part)
  end
  local n = #parts
  if n > 3 then
    return ".. " .. table.concat({ parts[n - 2], parts[n - 1], parts[n] }, "/")
  else
    return filepath
  end
end

local function lsp_servers_component()
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  if rawequal(next(clients), nil) then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    local n_tbl = {
      ["emmet_language_server"] = "emmet",
      ["graphql"] = "gql",
      ["lua_ls"] = "lua",
      ["tailwindcss"] = "tw",
      ["vtsls"] = "ts",
      ["vue_ls"] = "vue",
    }
    local name = n_tbl[client.name] or client.name

    table.insert(names, name)
  end

  local lsp_names = table.concat(names, ", ")
  return string.format("%s%s", highlight("StatuslineLSP"), pad_string(lsp_names))
end

local function diagnostics_component()
  local levels = {
    { key = "e", hl = "StatuslineError", severity = vim.diagnostic.severity.ERROR, label = "E" },
    { key = "w", hl = "StatuslineWarn", severity = vim.diagnostic.severity.WARN, label = "W" },
    { key = "i", hl = "StatuslineInfo", severity = vim.diagnostic.severity.INFO, label = "I" },
    { key = "h", hl = "StatuslineHint", severity = vim.diagnostic.severity.HINT, label = "H" },
  }

  local parts = {}
  for _, level in ipairs(levels) do
    local count = #vim.diagnostic.get(0, { severity = level.severity })
    if count > 0 then
      table.insert(parts, string.format("%s%s: %d", highlight(level.hl), level.label, count))
    end
  end

  return table.concat(parts, " ")
end

local function time_component()
  return string.format("%s%s", highlight("StatuslineTime"), tostring(os.date("%H:%M")))
end

Statusline.build = function()
  local content = table.concat({
    git_branch_component(),
    highlight("Statusline"),
    -- TODO: Pad this directly in the component
    pad_string(filepath_component()), -- File path
    diagnostics_component(),
    "%=", -- Separator
    lsp_servers_component(),
    time_component(),
    highlight("Statusline"),
  })

  -- TODO: Maybe set pad_string on each individual component instead
  return pad_string(content)
end

Statusline.setup = function()
  vim.o.laststatus = 3
  vim.o.statusline = "%{%v:lua.Statusline.build()%}"
end

return Statusline
