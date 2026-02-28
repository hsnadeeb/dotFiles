return function()
	local utils = require("config.utils")
	local map = utils.map

	local config = {
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
		update_focused_file = { enable = true, update_root = false, ignore_list = { "help" } },
		view = {
			width = 35,
			side = "left",
			preserve_window_proportions = true,
			number = false,
			relativenumber = false,
			signcolumn = "yes",
		},
		renderer = {
			group_empty = true,
			highlight_git = true,
			full_name = false,
			highlight_opened_files = "none",
			highlight_modified = "icon",
			root_folder_label = ":~:s?$?/..?",
			indent_width = 2,
			indent_markers = {
				enable = true,
				inline_arrows = true,
				icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
			},
			icons = {
				webdev_colors = true,
				git_placement = "before",
				modified_placement = "after",
				symlink_arrow = " ➛ ",
				show = { file = true, folder = true, folder_arrow = true, git = true, modified = true },
				glyphs = {
					default = "",
					symlink = "",
					bookmark = "󰆤",
					modified = "●",
					folder = {
						arrow_closed = "",
						arrow_open = "",
						default = "",
						open = "",
						empty = "",
						empty_open = "",
						symlink = "",
						symlink_open = "",
					},
					git = {
						unstaged = "✗",
						staged = "✓",
						unmerged = "",
						renamed = "➜",
						untracked = "★",
						deleted = "",
						ignored = "◌",
					},
				},
			},
		},
		actions = {
			use_system_clipboard = true,
			change_dir = { enable = true, global = true },
			expand_all = { max_folder_discovery = 300, exclude = { "node_modules", "target", "build" } },
			open_file = {
				quit_on_open = false,
				resize_window = true,
				window_picker = { enable = true, chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" },
			},
		},
		filters = { dotfiles = false, custom = {}, exclude = {} },
		git = { enable = true, ignore = false, show_on_dirs = true, timeout = 400 },
		diagnostics = {
			enable = true,
			show_on_dirs = true,
			debounce_delay = 50,
			icons = { hint = "", info = "", warning = "", error = "" },
		},
		log = { enable = false, truncate = true },
	}

	require("nvim-tree").setup(config)

	local api = require("nvim-tree.api")

	local function toggle_hidden_files()
		if vim.bo.filetype ~= "NvimTree" then
			api.tree.focus()
		end
		api.filter.dotfiles.toggle()
	end

	map("n", "<leader>n", api.tree.toggle, { desc = "Toggle NvimTree" })
	map("n", "<leader>e", function()
		if vim.bo.filetype == "NvimTree" then
			vim.cmd("wincmd p")
		else
			api.tree.focus()
		end
	end, { desc = "Toggle focus NvimTree/editor" })
	map("n", "<leader>h", toggle_hidden_files, { desc = "Toggle hidden files in NvimTree" })

	vim.api.nvim_create_autocmd("BufEnter", {
		nested = true,
		callback = function()
			local wins = vim.api.nvim_list_wins()
			local bufname = vim.api.nvim_buf_get_name(0)
			local argc = vim.fn.argc()

			if #wins == 1 and bufname:match("NvimTree_") ~= nil and argc == 0 then
				vim.cmd("quit")
			end
		end,
	})
end
