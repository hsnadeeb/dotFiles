return function()
	require("auto-session").setup({
		log_level = "error",
		auto_restore = true,
		auto_save = true,
		auto_create = true,
		suppressed_dirs = { "~/", "/", "~/Downloads", "/tmp" },
		use_git_branch = false,
		bypass_save_filetypes = { "alpha", "dashboard", "NvimTree", "gitcommit", "gitrebase", "nofile" },
		pre_save_cmds = {
			function()
				pcall(vim.cmd, "NvimTreeClose")
				pcall(vim.cmd, "Trouble diagnostics close")
				pcall(vim.cmd, "cclose")
			end,
		},
		post_restore_cmds = {
			function()
				vim.notify("Session restored successfully", vim.log.levels.INFO)
			end,
		},
	})

	local utils = require("config.utils")
	utils.map("n", "<leader>ss", "<cmd>Autosession save<CR>", { desc = "Save session" })
	utils.map("n", "<leader>sr", "<cmd>Autosession restore<CR>", { desc = "Restore session" })
	utils.map("n", "<leader>sd", "<cmd>Autosession delete<CR>", { desc = "Delete session" })
end
