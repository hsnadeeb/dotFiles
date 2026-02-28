return function()
  local refactoring = require("refactoring")

  refactoring.setup({
    prompt_func_repo = true,
    prompt_func_return_type = true,
    prompt_func_param_type = true,
    printf_statements = {},
    print_var_statements = {},
  })

  local utils = require("config.utils")
  local map = utils.map

  -- Extract function/method
  map("v", "<leader>re", ":Refactor extract ", { desc = "Extract to function" })
  map("v", "<leader>rf", ":Refactor extract_to_file ", { desc = "Extract to file" })

  -- Inline variable
  map("v", "<leader>ri", ":Refactor inline_var", { desc = "Inline variable" })

  -- Extract block to function
  map("n", "<leader>reb", ":Refactor extract_block ", { desc = "Extract block to function" })

  -- Refactoring keymaps (normal mode)
  map("n", "<leader>rp", function() require("refactoring").debug.print_var() end, { desc = "Print variable" })
  map("n", "<leader>rc", function() require("refactoring").debug.cleanup() end, { desc = "Cleanup debug prints" })
end
