return function()
  local cmp = require("cmp")
  cmp.setup({
    snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "copilot" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    }),
    formatting = {
      format = function(entry, vim_item)
        vim_item = require("lspkind").cmp_format({ mode = "symbol", maxwidth = 50 })(entry, vim_item)
        vim_item.menu = ({ copilot = "[Copilot]", nvim_lsp = "[LSP]", luasnip = "[Snippet]", buffer = "[Buffer]", path = "[Path]" })[entry.source.name]
        return vim_item
      end,
    },
  })
end
