-- ============================================================================
-- Neovim Settings
-- ============================================================================

local opt = vim.opt

-- Disable built-in plugins we don't need
local disabled_built_ins = {
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"matchit",
	"matchparen",
	"logiPat",
	"rrhelper",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
}

for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.synmaxcol = 240
opt.swapfile = false

-- Line numbers & cursor
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "number"

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Comments
opt.formatoptions = "jql"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Completion
opt.completeopt = "menuone,noselect,noinsert"
opt.shortmess:append("c")

-- Undo & backup
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.backup = true
opt.backupdir = vim.fn.stdpath("state") .. "/backup"
opt.directory = vim.fn.stdpath("state") .. "/swap"
opt.undolevels = 1000
opt.undoreload = 10000

-- UI
opt.termguicolors = true
opt.signcolumn = "yes:1"
opt.showmode = false
opt.showcmd = true
opt.cmdheight = 1
opt.laststatus = 3
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

-- Mouse & clipboard
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- File handling
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.fileformats = "unix,dos,mac"

-- Diff
opt.diffopt:append("vertical,iwhite,hiddenoff,algorithm:patience")

-- Wild menu
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore:append("*.o,*.obj,*.pyc,*.so,*.dll,*.zip,*.jpg,*.png,*.gif,*.pdf")

-- Folding
opt.foldmethod = "indent"
opt.foldlevelstart = 99

-- Session
opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Grep
if vim.fn.executable("rg") == 1 then
	opt.grepprg = "rg --vimgrep --no-heading --smart-case"
	opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Title
opt.title = true
opt.titlestring = '%t - NVIM (%{expand("%:p:h")})'

-- Split behavior
opt.splitkeep = "screen"

-- Clear search with ESC
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlights" })
