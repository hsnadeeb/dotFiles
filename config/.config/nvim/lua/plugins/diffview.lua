return function()
  local group = vim.api.nvim_create_augroup("DiffviewSyncWindows", { clear = true })
  local function sync_diff_windows()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.wo[win].diff then
        vim.wo[win].scrollbind = true
        vim.wo[win].cursorbind = false
      end
    end
  end

  require("diffview").setup({
    enhanced_diff_hl = true,
    use_icons = true,
    file_panel = {
      listing_style = "tree",
      win_config = { position = "left", width = 38 },
    },
    view = {
      merge_tool = {
        layout = "diff3_horizontal",
      },
    },
  })

  -- Keep both diff panes aligned while scrolling/cursoring (IDE-like behavior)
  vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
    group = group,
    callback = function()
      vim.schedule(sync_diff_windows)
    end,
  })
end
