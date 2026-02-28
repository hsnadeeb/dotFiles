-- ============================================================================
-- Global Keybindings (plugin-agnostic or lazy-safe wrappers)
-- ============================================================================

local utils = require("config.utils")
local actions = require("config.actions")
local map = utils.map

actions.register_user_commands()
actions.setup_lsp_attach_keymaps()

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Right window" })

-- Line navigation
map("n", "H", "^", { desc = "Start of line" })
map("n", "L", "$", { desc = "End of line" })
map("v", "H", "^", { desc = "Start of line" })
map("v", "L", "$", { desc = "End of line" })

-- Quickfix
map("n", "]q", ":cnext<CR>", { desc = "Next quickfix" })
map("n", "[q", ":cprev<CR>", { desc = "Prev quickfix" })

-- Buffer management (barbar)
map("n", "<leader>ww", ":BufferClose<CR>", { desc = "Close buffer" })
map("n", "<leader>wW", ":BufferClose!<CR>", { desc = "Force close buffer" })
map("n", "<leader>ws", ":w<CR>", { desc = "Save file" })
map("n", "<leader>wq", ":w | BufferClose<CR>", { desc = "Save and close" })
map("n", "<leader>wa", "<cmd>BufOnly<CR>", { desc = "Close all other buffers" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>q!<CR>", { desc = "Force quit" })

-- Select entire buffer
map("n", "<leader>y", "ggVG", { desc = "Select entire buffer" })

-- Telescope extras
map("n", "<leader>dd", actions.telescope_call("diagnostics", { bufnr = nil }), { desc = "Workspace Diagnostics" })
map("n", "<leader>fk", actions.telescope_call("keymaps"), { desc = "Find Keymaps" })
map("n", "<leader>fs", actions.telescope_call("lsp_document_symbols"), { desc = "Document Symbols" })
map("n", "<leader>fS", actions.telescope_call("lsp_workspace_symbols"), { desc = "Workspace Symbols" })
map("n", "<leader>fd", actions.telescope_call("lsp_definitions"), { desc = "LSP Definitions" })
map("n", "<leader>fi", actions.telescope_call("lsp_implementations"), { desc = "LSP Implementations" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git Commits" })
map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git Branches" })

-- DAP leader mappings
map("n", "<leader>dc", actions.dap_call("dap", "continue"), { desc = "Continue" })
map("n", "<leader>di", actions.dap_call("dap", "step_into"), { desc = "Step into" })
map("n", "<leader>do", actions.dap_call("dap", "step_over"), { desc = "Step over" })
map("n", "<leader>dO", actions.dap_call("dap", "step_out"), { desc = "Step out" })
map("n", "<leader>dl", actions.dap_call("dap", "run_last"), { desc = "Run last" })
map("n", "<leader>dx", actions.dap_call("dap", "terminate"), { desc = "Terminate" })
map("n", "<leader>du", actions.dap_call("dapui", "toggle"), { desc = "Toggle DAP UI" })
map("n", "<leader>dr", actions.toggle_dap_repl, { desc = "Toggle REPL" })

-- Theme cycling
map("n", "<leader>Tn", actions.theme_next, { desc = "Next Theme" })
map("n", "<leader>Tp", actions.theme_previous, { desc = "Previous Theme" })

-- Run current file helpers
map("n", "<leader>jr", actions.run_java_file, { desc = "Compile and run Java file" })
map("n", "<leader>pr", actions.run_python_file, { desc = "Run Python file" })
