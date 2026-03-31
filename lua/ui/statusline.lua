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

local function time_component()
  return string.format("%s%s", highlight("StatuslineTime"), tostring(os.date("%H:%M")))
end

Statusline.build = function()
  local content = table.concat({
    git_branch_component(),
    highlight("Statusline"),
    -- TODO: Pad this directly in the component
    pad_string(filepath_component()), -- File path
    vim.diagnostic.status(0),
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
