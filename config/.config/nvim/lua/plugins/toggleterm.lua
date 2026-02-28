return function()
  require("toggleterm").setup({
    size = 20, open_mapping = [[<c-\>]], hide_numbers = true, shade_filetypes = {}, shade_terminals = true,
    shading_factor = "1", start_in_insert = true, insert_mappings = true, persist_size = true,
    direction = "float", close_on_exit = true, shell = vim.o.shell, float_opts = { border = "curved" },
  })

  local utils = require("config.utils")
  local map = utils.map

  local function lazygit()
    require("toggleterm").exec("lazygit", nil, nil, nil, "float")
  end

  map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
  map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Float Terminal" })
  map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Vertical Terminal" })
  map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Horizontal Terminal" })
  map("n", "<leader>`", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle Horizontal Terminal" })
  map("n", "<leader>tg", lazygit, { desc = "Lazygit" })

  -- Terminal mode mappings
  -- Exit terminal insert mode with Escape
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal insert mode" })
  -- Alternative: Ctrl+Escape to send actual Escape to terminal
  vim.keymap.set("t", "<C-Esc>", "<Esc>", { desc = "Send Escape to terminal" })

  -- Window navigation from terminal mode
  vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Go to left window from terminal" })
  vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Go to window below from terminal" })
  vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Go to window above from terminal" })
  vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Go to right window from terminal" })
end
