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

  if #str == 0 then
    return ""
  end

  return string.format("%s%s %s", highlight("StatuslineGit"), "", str)
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

  local lsp_names = table.concat(names, " ")
  return pad_string(
    string.format(
      "%s%s%s%s%s%s",
      highlight("StatuslineLSPBracket"),
      "[",
      highlight("StatuslineLSP"),
      lsp_names,
      highlight("StatuslineLSPBracket"),
      "]"
    )
  )
end

local function time_component()
  return string.format("%s%s %s", highlight("StatuslineTime"), "Time:", tostring(os.date("%H:%M")))
end

Statusline.build = function()
  local content = table.concat({
    pad_string(git_branch_component(), 1, 0),
    highlight("Statusline"),
    pad_string(filepath_component()),
    vim.diagnostic.status(0),
    "%=", -- Separator
    lsp_servers_component(),
    pad_string(time_component(), 0, 1),
    highlight("Statusline"),
  })

  return content
end

Statusline.setup = function()
  vim.o.laststatus = 3
  vim.o.statusline = "%{%v:lua.Statusline.build()%}"
end

return Statusline
