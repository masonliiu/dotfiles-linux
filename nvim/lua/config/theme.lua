local c = {
  bg = "#060608",
  panel = "#0F1014",
  panel2 = "#1A1C21",
  text = "#F2F2F2",
  muted = "#7B7F87",
  accent = "#E33434",
  accent2 = "#D9DCE1",
  success = "#C9CDD4",
  warn = "#B8BDC5",
  error = "#EE4A4A",
}

local set = vim.api.nvim_set_hl
set(0, "Normal", { fg = c.text, bg = c.bg })
set(0, "NormalFloat", { fg = c.text, bg = c.panel })
set(0, "FloatBorder", { fg = c.accent, bg = c.panel })
set(0, "SignColumn", { bg = c.bg })
set(0, "LineNr", { fg = c.muted, bg = c.bg })
set(0, "CursorLineNr", { fg = c.accent, bg = c.bg, bold = true })
set(0, "Visual", { bg = c.panel2 })
set(0, "Search", { fg = c.bg, bg = c.warn })
set(0, "IncSearch", { fg = c.bg, bg = c.accent })
set(0, "Pmenu", { fg = c.text, bg = c.panel })
set(0, "PmenuSel", { fg = c.bg, bg = c.accent2 })
set(0, "StatusLine", { fg = c.text, bg = c.panel2 })
set(0, "StatusLineNC", { fg = c.muted, bg = c.panel })
set(0, "VertSplit", { fg = c.panel2, bg = c.bg })
set(0, "WinSeparator", { fg = c.panel2, bg = c.bg })
set(0, "Comment", { fg = c.muted, italic = true })
set(0, "String", { fg = c.success })
set(0, "Function", { fg = c.accent2 })
set(0, "Keyword", { fg = c.accent, bold = true })
set(0, "Type", { fg = c.accent2 })
set(0, "Error", { fg = c.error, bg = c.bg, bold = true })
set(0, "WarningMsg", { fg = c.warn, bg = c.bg })
