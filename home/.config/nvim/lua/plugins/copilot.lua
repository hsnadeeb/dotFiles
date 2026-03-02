return function()
  require("copilot").setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<Tab>",
        accept_line = "<C-l>",
        accept_word = "<C-Right>",
        next = "<M-j>",
        prev = "<M-k>",
        dismiss = "<C-]>",
      },
    },
    panel = { enabled = false },
  })
end
