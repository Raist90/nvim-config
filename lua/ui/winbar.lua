Winbar = {}

local function location_component()
  local navic = require("nvim-navic")
  local location = navic.get_location()
  if not location or location == "" then
    return ""
  end
  return string.format(" %s ", location)
end

Winbar.build = function(isActive)
  local highlight = function(hl)
    return isActive and hl or "%#WinbarNC#"
  end

  local winbar = table.concat({
    highlight("%#WinbarNormal#"),
    " ",
    highlight("%#WinbarFileName#"),
    -- File name
    " ",
    "%t",
    "%m",
    "%r ",

    -- Location
    highlight("%#WinbarLocation#"),
    location_component(),
    -- Spacer
    highlight("%#WinbarNormal#"),
    "%=",

    -- -- Other stuff
    -- highlight("%#WinbarDevinfo#"),
    -- " ",
    --
    -- "%#Normal#",
    -- " ",
  })

  return winbar
end

function Winbar.setup()
  vim.go.winbar =
    "%{%(nvim_get_current_win()==#g:actual_curwin) ? luaeval('Winbar.build(true)') : luaeval('Winbar.build(false)')%}"
end

return Winbar
