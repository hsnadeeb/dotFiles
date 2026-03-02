local function get_icon(kind, padding)
  local icon = ""
  if kind == "git" then
    icon = ""
  elseif kind == "diagnostics" then
    icon = ""
  end
  return icon .. string.rep(" ", padding or 0)
end

return function()
  require("lualine").setup({
    options = {
      theme = "auto",
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard" },
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "branch", icon = get_icon("git") },
        { "diff", symbols = { added = " ", modified = " ", removed = " " } },
        { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "H " } },
      },
      lualine_c = {
        { "filename", path = 1, symbols = { modified = " ", readonly = " ", unnamed = "[No Name]" } },
        { "searchcount", maxcount = 999, timeout = 500 },
      },
      lualine_x = {
        { "encoding", fmt = string.upper },
        { "fileformat", symbols = { unix = "LF", dos = "CRLF", mac = "CR" } },
        { "filetype", icon_only = true, separator = "" },
      },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = { function()
        return " " .. os.date("%R")
      end },
    },
    extensions = { "quickfix", "man", "trouble", "lazy" },
  })
end
