return function()
  require("trouble").setup({
    auto_preview = true,
    auto_close = false,
    focus = true,
    win = {
      position = "bottom",
      size = { height = 12 },
    },
    modes = {
      diagnostics = { auto_open = false },
    },
  })

  local utils = require("config.utils")
  local map = utils.map
  map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle Trouble" })
  map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Workspace Diagnostics" })
  map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Document Diagnostics" })
  map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix List" })
end
