return function()
  local ok, alpha = pcall(require, "alpha")
  if not ok then
    vim.notify("Alpha not loaded", vim.log.levels.WARN)
    return
  end

  local ok_theme, startify = pcall(require, "alpha.themes.startify")
  if not ok_theme then
    vim.notify("Alpha startify theme not loaded", vim.log.levels.WARN)
    return
  end

  -- Don't show alpha when opening a directory
  local function should_show_alpha()
    local argv = vim.fn.argv()
    if #argv == 0 then
      return true
    end
    -- Check if first argument is a directory
    if vim.fn.isdirectory(argv[1]) == 1 then
      return false
    end
    return true
  end

  if should_show_alpha() then
    -- Use default startify configuration
    alpha.setup(startify.config)

    -- Disable folding on alpha buffer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.opt_local.foldenable = false
      end,
    })
  end
end
