return function()
	local comment = require("Comment")
	comment.setup({
		padding = true,
		sticky = true,
		ignore = "^$",
		mappings = { basic = true, extra = false, extended = false },
	})

	local api = require("Comment.api")

	vim.keymap.set(
		"n",
		"<leader>/",
		api.toggle.linewise.current,
		{ silent = true, nowait = true, desc = "Toggle comment" }
	)
	vim.keymap.set(
		"x",
		"<leader>/",
		"<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
		{ silent = true, nowait = true, desc = "Toggle comment (selection)" }
	)

	local comment_ft = require("Comment.ft")
	comment_ft.set("lua", { "-- %s", "--[[%s]]" })
	comment_ft.set("vim", { '"%s', '"%s' })
	comment_ft.set("c", { "// %s", "/*%s*/" })
end
