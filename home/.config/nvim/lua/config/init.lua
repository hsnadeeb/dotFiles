-- ============================================================================
-- Neovim Configuration Entry Point
-- ============================================================================
-- Modular structure: config/ | keymaps/ | plugins/ | lsp/

local g = vim.g
local opt = vim.opt

-- Set leader keys
g.mapleader = " "
g.maplocalleader = " "

-- Disable optional language providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Ensure PATH
local function prepend_path(dir)
	if dir and dir ~= "" and vim.fn.isdirectory(dir) == 1 then
		local path = vim.env.PATH or ""
		if not string.find(path, dir, 1, true) then
			vim.env.PATH = dir .. ":" .. path
		end
	end
end

prepend_path("/opt/homebrew/bin")
prepend_path("/opt/homebrew/sbin")
prepend_path("/usr/local/bin")
prepend_path(vim.fn.expand("~/.local/bin"))
prepend_path(vim.fn.expand("~/go/bin"))

-- Theme persistence
local theme_persistence = require("theme_persistence")
g.saved_theme = theme_persistence.load_theme()

-- Package Manager: lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.notify("Installing lazy.nvim...", vim.log.levels.INFO)
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
opt.rtp:prepend(lazypath)

-- Load modules
require("config.settings")
require("config.utils")
require("plugins")
require("keymaps")
require("config.highlights")

-- Apply theme once plugin specs are registered
local ok_themes, themes = pcall(require, "plugins.themes")
if ok_themes and themes and themes.setup then
	local setup_ok = pcall(themes.setup)
	if not setup_ok then
		pcall(vim.cmd.colorscheme, "default")
	end
else
	pcall(vim.cmd.colorscheme, "default")
end

vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	command = "wincmd =",
})

-- Handle opening nvim with a directory argument
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local argv = vim.fn.argv()
		if #argv > 0 and vim.fn.isdirectory(argv[1]) == 1 then
			vim.cmd("enew")
			vim.cmd("NvimTreeToggle " .. vim.fn.fnameescape(argv[1]))
		end
	end,
})
