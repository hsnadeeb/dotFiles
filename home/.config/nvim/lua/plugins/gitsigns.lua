return function()
	local utils = require("config.utils")
	local gs = require("gitsigns")

	gs.setup({
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "┃" },
			topdelete = { text = "┃" },
			changedelete = { text = "┃" },
			untracked = { text = "┃" },
		},

		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,

		watch_gitdir = {
			interval = 2000,
			follow_files = true,
		},

		attach_to_untracked = true,
		update_debounce = 200,
		current_line_blame = false,

		preview_config = {
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},

		sign_priority = 6,
	})

	-- Keymaps
	utils.map("n", "<leader>gj", function()
		gs.nav_hunk("next")
	end, { desc = "Next Git Hunk" })
	utils.map("n", "<leader>gk", function()
		gs.nav_hunk("prev")
	end, { desc = "Prev Git Hunk" })
	utils.map("n", "<leader>ghs", function()
		gs.stage_hunk()
	end, { desc = "Stage Hunk" })
	utils.map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
	utils.map("n", "<leader>ghu", function()
		gs.undo_stage_hunk()
	end, { desc = "Undo Stage Hunk" })
	utils.map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset Hunk" })
	utils.map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
	utils.map("n", "<leader>ghd", gs.diffthis, { desc = "Hunk Diff" })
	utils.map("n", "<leader>ghD", function()
		gs.diffthis("~")
	end, { desc = "Hunk Diff (Staged)" })
	utils.map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
	utils.map("n", "<leader>gl", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
end
