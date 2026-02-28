local function apply_git_sign_highlights()
	vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#7EE787", bold = true })
	vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#79C0FF", bold = true })
	vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#FF7B72", bold = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = apply_git_sign_highlights,
})

apply_git_sign_highlights()
