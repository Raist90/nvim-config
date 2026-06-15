local pad_string = require("util").pad_string

local h = function(hl)
  return string.format("%%#%s#", hl)
end

Winbar = {}

Winbar.build = function(is_active)
  local f_tbl = {
    ["netrw"] = " %t %m",
  }

  local content = ""

  if f_tbl[vim.bo.filetype] then
    content = f_tbl[vim.bo.filetype]
  elseif f_tbl[vim.bo.buftype] then
    content = f_tbl[vim.bo.buftype]
  else
    local mode_hl
    if is_active then
      mode_hl = h("WinbarModeActive")
    else
      mode_hl = h("WinbarModeInactive")
    end
    local mode_text = " "
      .. vim.api.nvim_get_mode().mode:upper()
      .. " "
      .. string.format("%s%s", h(is_active and "WinbarSeparatorActive" or "WinbarSeparatorInactive"), "")
    local restore_hl = h(is_active and "WinbarActive" or "WinbarInactive")

    content = table.concat({
      is_active and mode_hl .. mode_text .. restore_hl or "",
      " %t",
      pad_string("%h%m%r%=%P"),
      is_active and string.format("%s%s", h("WinbarSeparator"), "") or "",
    })
  end

  local prefix = is_active and "%#WinbarActive#" or "%#WinbarInactive#"
  return prefix .. content
end

Winbar.setup = function()
  vim.o.winbar =
    "%{%(nvim_get_current_win()==#g:actual_curwin) ? luaeval('Winbar.build(true)') : luaeval('Winbar.build(false)')%}"
end

return Winbar
