return function()
	vim.g.barbar_auto_setup = false

	local ok, barbar = pcall(require, "barbar")
	if not ok then
		vim.notify("Failed to load barbar", vim.log.levels.WARN)
		return
	end

	barbar.setup({
		animation = true,
		auto_hide = false,
		tabpages = true,
		clickable = true,
		focus_on_close = "left",
		hide = { extensions = false, inactive = false },
		highlight_alternate = false,
		highlight_inactive_file_icons = false,
		highlight_visible = true,
		icons = {
			buffer_index = false,
			buffer_number = false,
			filetype = { enabled = true },
			button = "",
			modified = { button = "●" },
			pinned = { button = "", filename = true },
			inactive = { button = "" },
			separator = { left = "▎", right = "" },
		},
		insert_at_end = false,
		insert_at_start = false,
		maximum_padding = 1,
		minimum_padding = 1,
		maximum_length = 30,
		minimum_length = 0,
		semantic_letters = true,
		sidebar_filetypes = { NvimTree = true, ["neo-tree"] = { event = "BufWipeout" } },
		letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
		no_name_title = "[No Name]",
	})

	local utils = require("config.utils")
	local map = utils.map
	-- map("n", "<A-<>", ":BufferMovePrevious<CR>", { desc = "Move buffer left" })
	-- map("n", "<A->>", ":BufferMoveNext<CR>", { desc = "Move buffer right" })
	map("n", "<leader><Tab>", ":BufferMovePrevious<CR>", { desc = "Move buffer left" })
	map("n", "<leader><S-Tab>", ":BufferMoveNext<CR>", { desc = "Move buffer right" })
	map("n", "<A-p>", ":BufferPin<CR>", { desc = "Pin buffer" })
	map("n", "<Tab>", ":BufferNext<CR>", { desc = "Next buffer" })
	map("n", "<S-Tab>", ":BufferPrevious<CR>", { desc = "Prev buffer" })

	for i = 1, 8 do
		map("n", "<A-" .. i .. ">", ":BufferGoto " .. i .. "<CR>", { desc = "Go to buffer " .. i })
	end
end
