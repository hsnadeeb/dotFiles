return function()
  local dap = require("dap")
  local dapui = require("dapui")
  local utils = require("config.utils")
  local map = utils.map

  ---@diagnostic disable-next-line: undefined-field
  map("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
  ---@diagnostic disable-next-line: undefined-field
  map("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
  ---@diagnostic disable-next-line: undefined-field
  map("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
  ---@diagnostic disable-next-line: undefined-field
  map("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
  ---@diagnostic disable-next-line: undefined-field
  map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
  ---@diagnostic disable-next-line: undefined-field
  map("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Conditional Breakpoint" })

  dapui.setup()
  ---@diagnostic disable-next-line: undefined-field
  dap.listeners.after.event_initialized["dapui_config"] = dapui.open
  ---@diagnostic disable-next-line: undefined-field
  dap.listeners.before.event_terminated["dapui_config"] = dapui.close
  ---@diagnostic disable-next-line: undefined-field
  dap.listeners.before.event_exited["dapui_config"] = dapui.close

  require("nvim-dap-virtual-text").setup({})
end
