local M = {}

local state = { current = nil, initialized = false }

vim.opt.termguicolors = true
vim.opt.background = "dark"

local themes = {
  {
    name = "everforest",
    setup = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_better_performance = 0
      vim.g.everforest_diagnostic_text_highlight = 1
      vim.g.everforest_diagnostic_line_highlight = 1
      vim.g.everforest_diagnostic_virtual_text = "colored"
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_ui_contrast = "high"
      vim.cmd.colorscheme("everforest")
    end,
  },
  {
    name = "gruvbox",
    setup = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    name = "nightfox",
    setup = function()
      vim.cmd.colorscheme("carbonfox")
    end,
  },
  {
    name = "onedark",
    setup = function()
      vim.cmd.colorscheme("onedark")
    end,
  },
}

local persistence = require("theme_persistence")

local function get_theme(name)
  for _, theme in ipairs(themes) do
    if theme.name == name then
      return theme
    end
  end
  return themes[1]
end

local function show_theme_notification(theme_name)
  vim.schedule(function()
    vim.notify("Theme: " .. theme_name, vim.log.levels.INFO, { title = "Theme Switched", timeout = 1200 })
  end)
end

local function apply_theme(theme_name)
  if not theme_name then
    return nil
  end

  local theme = get_theme(theme_name)
  local ok = pcall(theme.setup)

  if not ok then
    if theme.name ~= "everforest" then
      vim.schedule(function()
        vim.notify("Theme '" .. theme_name .. "' failed, falling back to everforest", vim.log.levels.WARN)
      end)
      theme = themes[1]
      ok = pcall(theme.setup)
    end
    if not ok then
      vim.schedule(function()
        vim.notify("Failed to load any configured theme", vim.log.levels.ERROR)
      end)
      return nil
    end
  end

  state.current = theme.name
  persistence.save_theme(theme.name)
  show_theme_notification(theme.name)
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "ThemeChanged" })
  end)
  return theme.name
end

function M.next()
  local current = state.current or persistence.load_theme()
  local index = 1
  for i, t in ipairs(themes) do
    if t.name == current then
      index = i
      break
    end
  end
  local next_index = (index % #themes) + 1
  return apply_theme(themes[next_index].name)
end

function M.previous()
  local current = state.current or persistence.load_theme()
  local index = 1
  for i, t in ipairs(themes) do
    if t.name == current then
      index = i
      break
    end
  end
  local prev_index = (index - 2) % #themes + 1
  return apply_theme(themes[prev_index].name)
end

function M.set(name)
  return apply_theme(name)
end

M.cycle = M.next

function M.current()
  return state.current or persistence.load_theme()
end

function M.list()
  return vim.tbl_map(function(t)
    return t.name
  end, themes)
end

function M.setup()
  if state.initialized then
    return state.current
  end

  local theme = persistence.load_theme() or themes[1].name
  apply_theme(theme)
  state.initialized = true
  return theme
end

return M
