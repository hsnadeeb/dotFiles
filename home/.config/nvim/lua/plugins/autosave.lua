return function()
  local auto_save = require("auto-save")
  local pref_file = vim.fn.stdpath("state") .. "/autosave_enabled"

  local function load_preference()
    local f = io.open(pref_file, "r")
    if f then
      local content = f:read("*a")
      f:close()
      return content == "true"
    end
    return false
  end

  local function save_preference(enabled)
    local f = io.open(pref_file, "w")
    if f then
      f:write(enabled and "true" or "false")
      f:close()
    end
  end

  local saved_state = load_preference()
  local autosave_enabled = saved_state

  auto_save.setup({
    enabled = saved_state,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" },
      defer_save = { "InsertLeave", "TextChanged" },
      cancel_deferred_save = { "InsertEnter" },
    },
    callbacks = {
      after_saving = function()
        vim.notify("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"), vim.log.levels.INFO)
      end,
    },
    condition = function(buf)
      local fn = vim.fn
      local buftype = fn.getbufvar(buf, "&buftype")
      local filetype = fn.getbufvar(buf, "&filetype")
      if buftype ~= "" then
        return false
      end
      local excluded = { "NvimTree", "alpha", "TelescopePrompt", "lazy", "mason" }
      for _, ft in ipairs(excluded) do
        if filetype == ft then
          return false
        end
      end
      return fn.getbufvar(buf, "&modifiable") == 1
    end,
    write_all_buffers = false,
    debounce_delay = 1000,
  })

  local function toggle_autosave()
    auto_save.toggle()
    autosave_enabled = not autosave_enabled
    save_preference(autosave_enabled)
    vim.notify("AutoSave: " .. (autosave_enabled and "Enabled" or "Disabled"), vim.log.levels.INFO)
  end

  vim.api.nvim_create_user_command("AutoSaveToggle", toggle_autosave, { desc = "Toggle autosave" })

  local utils = require("config.utils")
  utils.map("n", "<leader>aa", "<cmd>AutoSaveToggle<CR>", { desc = "Toggle AutoSave" })
end
