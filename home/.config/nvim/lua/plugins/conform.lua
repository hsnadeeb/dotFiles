return function()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      go = { "goimports" },
      java = { "google-java-format" },
      sh = { "shfmt" },
      c = { "clang-format" },
    },
    format_on_save = { timeout_ms = 500 },
  })

  vim.keymap.set({ "n", "v" }, "<leader>fm", function() require("conform").format() end, { desc = "Format document" })
end
