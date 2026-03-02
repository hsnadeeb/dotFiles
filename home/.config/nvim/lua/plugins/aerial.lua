return function()
  require("aerial").setup({
    backends = { "lsp", "treesitter", "markdown", "man" },
    layout = { default_direction = "right", width = 0.3, min_width = 30 },
    show_guides = true,
    guides = { mid_item = "├──", last_item = "└──", nested_top = "│   ", whitespace = "  " },
    keymaps = {
      ["<CR>"] = "actions.jump", ["<2-LeftMouse>"] = "actions.jump",
      ["<C-v>"] = "actions.jump_vsplit", ["<C-s>"] = "actions.jump_split",
      ["p"] = "actions.scroll", ["<C-j>"] = "actions.down_and_scroll",
      ["<C-k>"] = "actions.up_and_scroll", ["q"] = "actions.close", ["?"] = "actions.show_help",
    },
    filter_kind = { "Class", "Constructor", "Enum", "Function", "Interface", "Method", "Struct" },
    icons = {
      Array = " ", Boolean = " ", Class = " ", Color = " ", Constant = " ",
      Constructor = " ", Enum = " ", EnumMember = " ", Event = " ", Field = " ",
      File = " ", Function = " ", Interface = " ", Key = " ", Method = " ",
      Module = " ", Namespace = " ", Null = " ", Number = " ", Object = " ",
      Operator = " ", Package = " ", Property = " ", String = " ", Struct = " ",
      TypeParameter = " ", Variable = " ",
    },
  })

  local utils = require("config.utils")
  utils.map("n", "<leader>m", "<cmd>AerialToggle!<CR>", { desc = "Toggle Code Structure" })
end
