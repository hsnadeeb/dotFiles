-- ============================================================================
-- Shared Action Functions
-- ============================================================================

local M = {}

-- Close all listed buffers except the current one and report skipped modified buffers.
function M.close_other_buffers()
  local current = vim.api.nvim_get_current_buf()
  local closed = 0
  local skipped = 0

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      local ok = pcall(vim.api.nvim_buf_delete, buf, { force = false })
      if ok then
        closed = closed + 1
      else
        skipped = skipped + 1
      end
    end
  end

  if skipped > 0 then
    vim.notify(("Closed %d buffers (%d skipped: likely modified)"):format(closed, skipped), vim.log.levels.WARN)
  else
    vim.notify(("Closed %d buffers"):format(closed), vim.log.levels.INFO)
  end
end

-- Create user commands owned by this config (idempotent on reload).
function M.register_user_commands()
  pcall(vim.api.nvim_del_user_command, "BufOnly")
  vim.api.nvim_create_user_command("BufOnly", M.close_other_buffers, {
    desc = "Close all listed buffers except current",
  })
end

-- Build a lazy-safe Telescope action by picker name.
function M.telescope_call(fn_name, opts)
  return function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if not ok then
      vim.notify("Telescope is not available", vim.log.levels.WARN)
      return
    end
    builtin[fn_name](opts or {})
  end
end

-- Build a lazy-safe DAP/DAPUI action by module and function name.
function M.dap_call(mod, fn)
  return function()
    local ok, m = pcall(require, mod)
    if not ok then
      vim.notify(mod .. " is not available", vim.log.levels.WARN)
      return
    end
    local f = m[fn]
    if type(f) == "function" then
      f()
    end
  end
end

-- Toggle the DAP REPL if DAP is available.
function M.toggle_dap_repl()
  local ok, dap = pcall(require, "dap")
  if not ok then
    vim.notify("dap is not available", vim.log.levels.WARN)
    return
  end
  dap.repl.toggle()
end

-- Switch to the next configured theme.
function M.theme_next()
  local ok, themes = pcall(require, "plugins.themes")
  if ok then
    themes.next()
  end
end

-- Switch to the previous configured theme.
function M.theme_previous()
  local ok, themes = pcall(require, "plugins.themes")
  if ok then
    themes.previous()
  end
end

-- Open a one-off ToggleTerm instance for a shell command.
local function run_file_in_term(cmd)
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    close_on_exit = false,
  })
  term:toggle()
end

-- Compile and run the current Java file.
function M.run_java_file()
  if vim.fn.expand("%:e") == "java" then
    local class_name = vim.fn.shellescape(vim.fn.expand("%:t:r"))
    local dir = vim.fn.shellescape(vim.fn.expand("%:p:h"))
    local file = vim.fn.shellescape(vim.fn.expand("%:t"))
    run_file_in_term("cd " .. dir .. " && javac " .. file .. " && java " .. class_name)
  else
    vim.notify("Not a Java file", vim.log.levels.WARN)
  end
end

-- Run the current Python file.
function M.run_python_file()
  if vim.fn.expand("%:e") == "py" then
    local file = vim.fn.shellescape(vim.fn.expand("%:p"))
    run_file_in_term("python3 " .. file)
  else
    vim.notify("Not a Python file", vim.log.levels.WARN)
  end
end

return M
