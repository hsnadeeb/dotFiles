return function()
	local autopairs = require("nvim-autopairs")
	local Rule = require("nvim-autopairs.rule")
	local cond = require("nvim-autopairs.conds")

	autopairs.setup({
		check_ts = true,
		ts_config = { lua = { "string" }, javascript = { "template_string" }, java = false },
		disable_filetype = { "TelescopePrompt", "spectre_panel", "dap-repl" },
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = 0,
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "Search",
			highlight_grey = "Comment",
		},
		enable_check_bracket_line = false,
		ignored_next_char = "[%w%.]",
		break_undo = true,
	})

	local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
	autopairs.add_rules({
		Rule(" ", " ")
			:with_pair(function(opts)
				local pair = opts.line:sub(opts.col - 1, opts.col)
				return vim.tbl_contains({ "()", "[]", "{}" }, pair)
			end)
			:with_move(cond.none())
			:with_cr(cond.none())
			:with_del(function(opts)
				local col = vim.api.nvim_win_get_cursor(0)[2]
				local context = opts.line:sub(col - 1, col + 2)
				return vim.tbl_contains({ "(  )", "[  ]", "{  }", "\n  \n" }, context)
			end),
	})

	for _, bracket in ipairs(brackets) do
		autopairs.add_rules({
			Rule(bracket[1] .. " ", " " .. bracket[2])
				:with_pair(function()
					return false
				end)
				:with_move(function(opts)
					return opts.char == bracket[2]
				end)
				:with_cr(cond.none())
				:with_del(function(opts)
					return opts.line:sub(opts.col - #bracket[1], opts.col - 1) == bracket[1] .. " "
						and opts.line:sub(opts.col, opts.col + #bracket[2] + 1) == " " .. bracket[2]
				end),
		})
	end

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	---@type any
	local cmp = require("cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
