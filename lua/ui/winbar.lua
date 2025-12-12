local pad_string = require("util").pad_string

Winbar = {}

Winbar.build = function(is_active)
  local highlight = function(hl)
    return is_active and hl or "%#WinbarInactive#"
  end

  local f_tbl = {
    ["copilot-chat"] = "%t",
    ["netrw"] = "%t %m",
    ["terminal"] = "%t %m",
  }

  local content = ""

  if f_tbl[vim.bo.filetype] then
    content = f_tbl[vim.bo.filetype]
  elseif f_tbl[vim.bo.buftype] then
    content = f_tbl[vim.bo.buftype]
  else
    content = table.concat({
      "%t",
      "%h%m%r%=%P",
    })
  end
  return pad_string(highlight("%#WinbarActive#") .. content)
end

Winbar.setup = function()
  vim.o.winbar =
    "%{%(nvim_get_current_win()==#g:actual_curwin) ? luaeval('Winbar.build(true)') : luaeval('Winbar.build(false)')%}"
end

return Winbar
