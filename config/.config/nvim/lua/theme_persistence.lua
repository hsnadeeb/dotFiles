local M = {}

-- Constants
local CACHE_FILE = vim.fn.stdpath("state") .. "/theme_cache"
local DEFAULT_THEME = "everforest"

-- Module state
local cached_theme = nil
local save_timer = nil

local function write_theme_to_file(theme_name)
  local file = io.open(CACHE_FILE, "w")
  if not file then
    return false
  end

  local success = file:write(theme_name) and true or false
  file:close()
  return success
end

function M.save_theme(theme_name)
  if not theme_name or theme_name == "" then
    return false
  end

  cached_theme = theme_name

  if save_timer then
    save_timer:stop()
    save_timer = nil
  end

  save_timer = vim.defer_fn(function()
    local ok = write_theme_to_file(theme_name)
    if not ok then
      vim.notify("Failed to save theme preference", vim.log.levels.WARN)
    end
    save_timer = nil
  end, 300)

  return true
end

function M.load_theme()
  if cached_theme then
    return cached_theme
  end

  local file = io.open(CACHE_FILE, "r")
  if file then
    local theme = file:read("*l")
    file:close()

    if theme and theme ~= "" then
      cached_theme = theme
      return theme
    end
  end

  cached_theme = DEFAULT_THEME
  return DEFAULT_THEME
end

function M.clear_cache()
  cached_theme = nil
  if save_timer then
    save_timer:stop()
    save_timer = nil
  end
  return true
end

function M.get_status()
  return {
    current_theme = M.load_theme(),
    cache_file = CACHE_FILE,
    has_pending_write = save_timer ~= nil,
  }
end

return M
