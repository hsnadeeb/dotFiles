-- ============================================================================
-- LSP Configuration
-- ============================================================================

local M = {}
local configured = false

local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }
  local map = vim.keymap.set

  -- Keep formatting ownership with conform for TS/JS stacks
  if client.name == "ts_ls" or client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end

  -- Keep LSP mappings under <leader>l to avoid clashes with normal motion keys.
  map("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: Code Action" }))
  map("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "LSP: Diagnostics" }))
  map("n", "<leader>lD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP: Declaration" }))
  map("n", "<leader>ll", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: Definition" }))
  map("n", "<leader>li", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP: Implementation" }))
  map("n", "<leader>lr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP: References" }))
  map("n", "<leader>lt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "LSP: Type Definition" }))
  map("n", "<leader>lf", function()
    local ok_conform, conform = pcall(require, "conform")
    if ok_conform then
      conform.format()
      return
    end
    vim.lsp.buf.format()
  end, vim.tbl_extend("force", opts, { desc = "LSP: Format" }))
  map("n", "<leader>lh", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: Hover" }))
  map("n", "<leader>lk", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "LSP: Signature Help" }))
  map("n", "<leader>ln", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: Rename" }))
  map("n", "<leader>ls", vim.lsp.buf.document_symbol, vim.tbl_extend("force", opts, { desc = "LSP: Document Symbols" }))
  map("n", "<leader>lS", vim.lsp.buf.workspace_symbol, vim.tbl_extend("force", opts, { desc = "LSP: Workspace Symbols" }))
  map("n", "<leader>lj", function()
    vim.diagnostic.jump({ count = 1 })
  end, vim.tbl_extend("force", opts, { desc = "LSP: Next Diagnostic" }))
  map("n", "<leader>lp", function()
    vim.diagnostic.jump({ count = -1 })
  end, vim.tbl_extend("force", opts, { desc = "LSP: Previous Diagnostic" }))

  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

local function setup_diagnostics()
  local signs = {
    [vim.diagnostic.severity.ERROR] = "E",
    [vim.diagnostic.severity.WARN] = "W",
    [vim.diagnostic.severity.HINT] = "H",
    [vim.diagnostic.severity.INFO] = "I",
  }

  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      spacing = 2,
      source = "if_many",
    },
    float = {
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
    signs = { text = signs },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end

function M.setup()
  if configured then
    return
  end

  setup_diagnostics()

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local default_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }

  local servers = {
    ts_ls = {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    },
    html = {},
    cssls = {},
    eslint = {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
    },
    gopls = {
      filetypes = { "go", "gomod" },
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    },
    jsonls = {},
    lua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" }, disable = { "trailing-space" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    },
    jdtls = {},
  }

  local has_native_config = vim.fn.has("nvim-0.11") == 1

  if has_native_config then
    for server, config in pairs(servers) do
      vim.lsp.config(server, vim.tbl_deep_extend("force", default_opts, config))
      vim.lsp.enable(server)
    end
  else
    local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
    if ok_lspconfig then
      for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_deep_extend("force", default_opts, config))
      end
    end
  end

  local ok_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
  if ok_mason_lsp then
    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
    })
  end

  configured = true
end

return M
