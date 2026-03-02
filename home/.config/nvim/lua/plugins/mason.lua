return function()
  require("mason").setup({ ui = { border = "rounded" } })

  require("mason-tool-installer").setup({
    ensure_installed = {
      -- LSPs
      "typescript-language-server",
      "html-lsp",
      "css-lsp",
      "eslint-lsp",
      "gopls",
      "jdtls",
      "json-lsp",
      "lua-language-server",
      -- Formatters
      "prettier",
      "goimports",
      "stylua",
      "shfmt",
      "clang-format",
      "google-java-format",
      -- Debug adapters
      "java-debug-adapter",
      "delve",
    },
    auto_update = false,
    run_on_start = false,
    start_delay = 3000,
  })

  require("mason-lspconfig").setup({
    ensure_installed = { "ts_ls", "html", "cssls", "eslint", "gopls", "jdtls", "jsonls", "lua_ls" },
    automatic_installation = true,
  })
end
