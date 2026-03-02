return function()
  local utils = require("config.utils")
  local map = utils.map

  require("ibl").setup({
    indent = { char = "┊", tab_char = "▏", highlight = { "Whitespace", "IblIndent" }, smart_indent_cap = true, priority = 1 },
    scope = { show_start = true, show_end = true, show_exact_scope = false, highlight = { "IblScope" }, priority = 2 },
    exclude = { filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify", "toggleterm", "lazyterm", "qf", "terminal" }, buftypes = { "terminal", "nofile", "quickfix", "prompt" } },
  })

  vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4048", nocombine = true })
  vim.api.nvim_set_hl(0, "IblScope", { fg = "#4b5262", nocombine = true })

  map("n", "<leader>ui", function()
    require("ibl").toggle()
    vim.notify("Indent guides " .. (require("ibl").is_enabled() and "enabled" or "disabled"))
  end, { desc = "Toggle indent guides" })
end
