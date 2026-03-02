return function()
	---@type any
	local telescope = require("telescope")
	local builtin = require("telescope.builtin")
	local utils = require("config.utils")
	local map = utils.map

	telescope.setup({
		defaults = {
			preview = { treesitter = false },
			prompt_prefix = "   ",
			selection_caret = "  ",
			path_display = { "truncate" },
			file_ignore_patterns = { "^%.git/", "^node_modules/", "^%.DS_Store$", "^target/" },
			mappings = {
				i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous", ["<C-c>"] = "close" },
				n = { ["q"] = "close" },
			},
		},
	})

	pcall(telescope.load_extension, "fzf")

	map("n", "<leader>ff", function()
		builtin.find_files({ hidden = true, no_ignore = false, follow = true })
	end, { desc = "Find Files" })
	map("n", "<leader>fg", function()
		builtin.live_grep({ hidden = true, no_ignore = false })
	end, { desc = "Live Grep" })
	map("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
	map("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
	map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
end
