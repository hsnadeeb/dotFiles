# Neovim Configuration

A modern, modular Neovim configuration optimized for Go, Java, TypeScript/JavaScript, Lua, and general development. Built for Neovim 0.10+ with native LSP support.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Directory Structure](#directory-structure)
- [Keybindings](#keybindings)
- [Plugins](#plugins)
- [Customization](#customization)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)

---

## Features

### Core Features
- **Fast startup**: Lazy-loaded plugins with lazy.nvim
- **Native LSP**: Uses Neovim 0.11+ native LSP configuration
- **Auto-completion**: nvim-cmp with LSP, buffer, and path sources
- **Syntax highlighting**: Tree-sitter powered
- **Session management**: Manual session save/restore
- **Multiple themes**: 4 built-in themes with persistence
- **Terminal integration**: Floating and split terminals
- **Debugging**: Full DAP support for Go and Java

### Language Support
- **Go**: gopls, goimports, delve debugger
- **Java**: jdtls, google-java-format, java-debug-adapter
- **TypeScript/JavaScript**: ts_ls, eslint, prettier
- **Lua**: lua_ls, stylua
- **HTML/CSS**: html-lsp, css-lsp
- **JSON**: jsonls
- **Shell**: shfmt
- **C/C++**: clangd (via Mason), clang-format

### UI Enhancements
- Status line (lualine)
- Buffer tabs (barbar)
- File explorer (nvim-tree)
- Fuzzy finder (telescope)
- Code structure view (aerial)
- Git integration (gitsigns)
- Diagnostics panel (trouble)
- Auto-pairs and commenting

---

## Prerequisites

### Required
- Neovim 0.10+ (0.11+ recommended)
- Git
- A Nerd Font (for icons)
- ripgrep (`rg`) - for telescope
- fd - for telescope

### Optional (but recommended)
- Node.js (for LSP servers and formatters)
- Go (for gopls and Go tools)
- Java 17+ (for jdtls)
- Python 3 (for some tools)

### macOS Installation
```bash
# Install Neovim
brew install neovim

# Install required tools
brew install git ripgrep fd wget

# Optional languages
brew install node go python3
brew install --cask temurin  # Java
```

---

## Installation

1. **Backup existing config** (if any):
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. **Clone this repository**:
```bash
git clone <your-repo-url> ~/.config/nvim
```

3. **Start Neovim**:
```bash
nvim
```

Lazy.nvim will automatically install all plugins on first launch.

4. **Install LSP servers and tools**:
```vim
:Mason
```
Recommended on first setup to verify tool installation status.

5. **Check health**:
```vim
:checkhealth
```

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/
│   │   ├── init.lua           # Main configuration loader
│   │   ├── settings.lua       # Neovim settings
│   │   ├── utils.lua          # Utility functions
│   │   └── highlights.lua     # Custom highlights/autocmds
│   ├── keymaps.lua            # Global keybindings
│   ├── lsp/
│   │   └── init.lua           # LSP configuration
│   ├── plugins/              # Individual plugin configs
│   │   ├── aerial.lua
│   │   ├── alpha.lua
│   │   ├── autopairs.lua
│   │   ├── autosave.lua
│   │   ├── barbar.lua
│   │   ├── cmp.lua
│   │   ├── comment.lua
│   │   ├── conform.lua
│   │   ├── copilot.lua
│   │   ├── copilot_cmp.lua
│   │   ├── dap.lua
│   │   ├── diffview.lua
│   │   ├── gitsigns.lua
│   │   ├── indent_blankline.lua
│   │   ├── lspsaga.lua
│   │   ├── lualine.lua
│   │   ├── mason.lua
│   │   ├── nvimtree.lua
│   │   ├── project.lua
│   │   ├── refactoring.lua
│   │   ├── session.lua
│   │   ├── spectre.lua
│   │   ├── telescope.lua
│   │   ├── themes.lua
│   │   ├── toggleterm.lua
│   │   ├── todo_comments.lua
│   │   ├── trouble.lua
│   │   └── which_key.lua
│   ├── plugins.lua            # Main plugin definitions
│   ├── lsp/
│   │   └── init.lua           # LSP setup
│   └── theme_persistence.lua  # Theme persistence logic
└── ftplugin/
    └── java.lua               # Java-specific settings
```

---

## Keybindings

### Leader Key
- `<Space>` is the leader key

### General Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<C-h/j/k/l>` | Normal | Navigate between windows |
| `H` | Normal/Visual | Jump to start of line |
| `L` | Normal/Visual | Jump to end of line |
| `]q` / `[q` | Normal | Next/Previous quickfix item |
| `<Esc>` | Normal | Clear search highlights |

### Buffer Management (Barbar)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader><Tab>` | Normal | Move buffer left |
| `<leader><S-Tab>` | Normal | Move buffer right |
| `<A-p>` | Normal | Pin/unpin buffer |
| `<Tab>` | Normal | Next buffer |
| `<S-Tab>` | Normal | Previous buffer |
| `<A-1..8>` | Normal | Go to buffer 1-8 |

**Buffer Leader Keys:**
| Key | Description |
|-----|-------------|
| `<leader>ww` | Close buffer |
| `<leader>wW` | Force close buffer |
| `<leader>ws` | Save file |
| `<leader>wq` | Save and close buffer |
| `<leader>wa` | Close all other buffers |

### File Operations

| Key | Description |
|-----|-------------|
| `<leader>n` | Toggle NvimTree file explorer |
| `<leader>e` | Focus NvimTree / go back to editor |
| `<leader>h` | Toggle hidden files in NvimTree |
| `<leader>y` | Select entire buffer |

### Window Management

| Key | Description |
|-----|-------------|
| `<leader>q` | Quit |
| `<leader>Q` | Force quit |

### LSP (Language Server Protocol)

| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find references |
| `gt` | Go to type definition |
| `K` | Show hover documentation |
| `<C-k>` | Show signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous/Next diagnostic |

**IntelliJ-like shortcuts:**
| Key | Description |
|-----|-------------|
| `<leader>bb` | Go to definition (Cmd+B style) |
| `<leader>bi` | Go to implementation |
| `<leader>br` | Find usages (references) |

**Leader LSP Menu (`<leader>l`):**
| Key | Description |
|-----|-------------|
| `<leader>la` | Code action |
| `<leader>ld` | Diagnostics |
| `<leader>lD` | Declaration |
| `<leader>li` | Implementation |
| `<leader>lr` | References |
| `<leader>ln` | Rename |
| `<leader>lf` | Format |
| `<leader>lh` | Hover |

### Telescope (Fuzzy Finder)

| Key | Description |
|-----|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>fk` | Find keymaps |
| `<leader>fs` | Document symbols |
| `<leader>fS` | Workspace symbols |
| `<leader>fd` | LSP definitions |
| `<leader>fi` | LSP implementations |

### Git (Gitsigns + Diffview + Lazygit)

| Key | Description |
|-----|-------------|
| `<leader>gc` | Git commits |
| `<leader>gb` | Git branches |
| `<leader>gs` | Open Diffview |
| `<leader>gD` | Close Diffview |
| `<leader>gB` | File history in Diffview |
| `<leader>gj` | Next hunk |
| `<leader>gk` | Previous hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gl` | Toggle line blame |

**Hunk Operations (`<leader>gh...`):**
| Key | Description |
|-----|-------------|
| `<leader>ghs` | Stage hunk |
| `<leader>ghS` | Stage buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghR` | Reset buffer |
| `<leader>ghd` | Hunk diff |
| `<leader>ghD` | Hunk diff (staged) |

### Terminal (ToggleTerm)

**Opening/Closing:**
| Key | Description |
|-----|-------------|
| `<C-\>` | Toggle floating terminal |
| `<leader>tt` | Toggle terminal |
| `<leader>tf` | Float terminal |
| `<leader>tv` | Vertical terminal |
| `<leader>th` | Horizontal terminal |
| `<leader>`\` | Toggle horizontal terminal (quick access) |
| `<leader>tg` | Lazygit |

**Terminal Mode (when inside terminal):**
| Key | Description |
|-----|-------------|
| `<Esc>` | Exit terminal insert mode (go to terminal normal mode) |
| `<C-Esc>` | Send actual Escape to terminal program |
| `<C-h/j/k/l>` | Navigate to other windows from terminal |

### Debugging (DAP)

| Key | Description |
|-----|-------------|
| `<F5>` | Start/Continue debugging |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dr` | Toggle REPL |
| `<leader>dl` | Run last debug session |
| `<leader>du` | Toggle DAP UI |
| `<leader>dx` | Terminate |

### Session Management

| Key | Description |
|-----|-------------|
| `<leader>ss` | Save session |
| `<leader>sr` | Restore session |
| `<leader>sd` | Delete session |

### Diagnostics (Trouble)

| Key | Description |
|-----|-------------|
| `<leader>xx` | Toggle Trouble |
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |
| `<leader>xq` | Quickfix list |

### Search & Replace (Spectre)

| Key | Description |
|-----|-------------|
| `<leader>rw` | Replace word under cursor |
| `<leader>rp` | Replace in project |
| `<leader>rf` | Replace in file |
| `<leader>sw` | Replace word/selection |
| `<leader>sf` | Replace in file (direct) |
| `<leader>sp` | Replace in project (direct) |

### Refactoring

| Key | Description |
|-----|-------------|
| `<leader>re` | Extract to function (visual) |
| `<leader>rf` | Extract to file (visual) |
| `<leader>ri` | Inline variable (visual) |
| `<leader>reb` | Extract block |

### Code Structure (Aerial)

| Key | Description |
|-----|-------------|
| `<leader>m` | Toggle code structure view |

### Theme Switching

| Key | Description |
|-----|-------------|
| `<leader>Tn` | Next theme |
| `<leader>Tp` | Previous theme |

### Auto-save

| Key | Description |
|-----|-------------|
| `<leader>aa` | Toggle auto-save |

### Which-Key

Press any leader key combination and wait to see available options.

---

## Plugins

### Plugin Manager
- **lazy.nvim**: Modern plugin manager with lazy loading

### UI
- **lualine.nvim**: Status line
- **barbar.nvim**: Buffer tabs
- **nvim-tree.lua**: File explorer
- **alpha-nvim**: Dashboard
- **indent-blankline.nvim**: Indentation guides
- **nvim-web-devicons**: File type icons

### Themes
- **everforest**: Primary theme (soft green)
- **gruvbox.nvim**: Retro theme
- **nightfox.nvim**: Dark theme with variants
- **onedark.nvim**: Atom One Dark theme

### LSP & Completion
- **nvim-lspconfig**: LSP configuration
- **mason.nvim**: LSP server installer
- **mason-lspconfig.nvim**: Bridge between mason and lspconfig
- **mason-tool-installer.nvim**: Automatic tool installation
- **nvim-cmp**: Auto-completion framework
- **cmp-nvim-lsp**: LSP completion source
- **cmp-buffer**: Buffer completion source
- **cmp-path**: Path completion source
- **LuaSnip**: Snippet engine
- **lspkind-nvim**: Completion item icons
- **lspsaga.nvim**: Enhanced LSP UI

### Editing
- **nvim-autopairs**: Auto-close brackets
- **Comment.nvim**: Easy commenting
- **refactoring.nvim**: Code refactoring tools

### Search
- **telescope.nvim**: Fuzzy finder
- **telescope-fzf-native.nvim**: FZF algorithm for telescope
- **nvim-spectre**: Find and replace

### Git
- **gitsigns.nvim**: Git decorations and actions
- **diffview.nvim**: Git diff and file-history views

### Terminal
- **toggleterm.nvim**: Integrated terminal and lazygit floating terminal

### Debugging
- **nvim-dap**: Debug adapter protocol
- **nvim-dap-ui**: DAP UI
- **nvim-dap-virtual-text**: Variable values as virtual text
- **nvim-jdtls**: Java LSP/debugging

### Session & Project
- **auto-session**: Session management
- **project.nvim**: Project detection and navigation

### Syntax
- **nvim-treesitter**: Syntax highlighting and parsing

### Other
- **conform.nvim**: Code formatting
- **trouble.nvim**: Diagnostics list
- **todo-comments.nvim**: Highlight TODO comments
- **aerial.nvim**: Code outline/symbol tree
- **which-key.nvim**: Keybinding helper
- **lazydev.nvim**: Lua development for Neovim
- **neoconf.nvim**: Neovim configuration helper

---

## Customization

### Adding a New Plugin

1. **Edit `lua/plugins.lua`**:

```lua
-- Example: Add nvim-colorizer.lua
{
  "NvChad/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    require("colorizer").setup()
  end,
}
```

2. **Create config file** (optional, for complex configs):
Create `lua/plugins/colorizer.lua`:

```lua
return function()
  require("colorizer").setup({
    -- Your configuration
  })
end
```

Then reference it:
```lua
{
  "NvChad/nvim-colorizer.lua",
  config = require("plugins.colorizer"),
}
```

3. **Reload Neovim**:
```vim
:Lazy sync
```

### Adding New Keybindings

**Global keymaps**: Edit `lua/keymaps.lua`

```lua
-- Add to which-key registration (optional)
wk.register({
  ["<leader>n"] = {
    name = "+new-category",
    a = { "<cmd>SomeCommand<CR>", "Description" },
    b = { function() print("Hello") end, "Another action" },
  },
})

-- Or use map helper directly
map("n", "<leader>nx", "<cmd>Command<CR>", { desc = "Description" })
```

**Buffer-local keymaps**: Use in plugin config or LSP attach

```lua
-- In LSP on_attach or plugin config
vim.keymap.set("n", "<leader>xx", function()
  -- Your function
end, { buffer = bufnr, desc = "Description" })
```

### Adding LSP Support for New Languages

1. **Edit `lua/lsp/init.lua`**:

```lua
local servers = {
  -- Add your new server
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
      },
    },
  },
  -- ... existing servers
}
```

2. **Add to mason auto-install**: Edit `lua/plugins/mason.lua`

```lua
require("mason-tool-installer").setup({
  ensure_installed = {
    -- Add LSP server name
    "rust-analyzer",
    -- ... existing tools
  },
})

require("mason-lspconfig").setup({
  ensure_installed = { 
    "rust_analyzer",  -- Add here too
    -- ... existing servers
  },
})
```

3. **Restart Neovim** and run `:Mason` to verify/install missing tools.

### Adding a Formatter

1. **Edit `lua/plugins/conform.lua`**:

```lua
formatters_by_ft = {
  -- Add new filetype
  rust = { "rustfmt" },
  -- ... existing formatters
}
```

2. **Add to mason** (in `lua/plugins/mason.lua`):

```lua
ensure_installed = {
  "rustfmt",
  -- ... existing formatters
}
```

3. **Restart Neovim**.

### Adding a New Theme

1. **Add theme plugin** in `lua/plugins.lua`:

```lua
{ "catppuccin/nvim", name = "catppuccin", lazy = true },
```

2. **Edit `lua/plugins/themes.lua`**:

```lua
local themes = {
  -- Add new theme
  {
    name = "catppuccin",
    setup = function()
      local ok, catppuccin = pcall(require, "catppuccin")
      if not ok then return end
      catppuccin.setup({
        flavour = "mocha",
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  -- ... existing themes
}
```

3. **Switch to new theme**: Use `<leader>Tn` to cycle themes or restart Neovim.

---

## Maintenance

### Updating Plugins

```vim
:Lazy sync    " Update and sync all plugins
:Lazy update  " Update plugins only
:Lazy clean   " Remove unused plugins
```

### Updating LSP Servers

```vim
:Mason                    " Open Mason UI
:MasonUpdate              " Update all Mason packages
:MasonInstall <package>   " Install specific package
```

### Health Checks

```vim
:checkhealth              " Full health check
:checkhealth mason        " Mason-specific
:checkhealth lspconfig    " LSP-specific
:checkhealth treesitter   " Treesitter-specific
```

### Clearing Cache

If you experience issues:

```bash
# Clear lazy.nvim cache
rm -rf ~/.local/share/nvim/lazy

# Clear sessions
rm -rf ~/.local/share/nvim/sessions

# Clear all state (nuclear option)
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
```

Then restart Neovim.

### Backing Up Configuration

```bash
# Create backup
cd ~/.config
 tar -czf nvim-backup-$(date +%Y%m%d).tar.gz nvim/

# Or with git
cd ~/.config/nvim
git add .
git commit -m "Backup: $(date)"
git push
```

---

## Troubleshooting

### Plugin Won't Load

1. Check for errors on startup:
```vim
:messages
```

2. Check lazy.nvim status:
```vim
:Lazy
```

3. Try reinstalling the plugin:
```vim
:Lazy clean
:Lazy sync
```

### LSP Not Working

1. Check if server is installed:
```vim
:Mason
```

2. Check LSP logs:
```vim
:LspLog
```

3. Verify LSP is attached:
```vim
:LspInfo
```

4. Check for errors:
```vim
:checkhealth vim.lsp
```

### Formatter Not Working

1. Check formatter status:
```vim
:ConformInfo
```

2. Verify formatter is installed:
```vim
:Mason
```

3. Check conform logs:
```bash
cat ~/.local/state/nvim/conform.log
```

### Theme Not Loading

1. Check if theme is installed:
```vim
:colorscheme <Tab>
```

2. Check for errors:
```vim
:messages
```

3. Clear theme cache:
```bash
rm ~/.config/nvim/.theme_cache
```

### Slow Startup

1. Profile startup:
```bash
nvim --startuptime /tmp/startup.log
```

2. Check which plugins are slow in lazy.nvim:
```vim
:Lazy profile
```

3. Consider lazy-loading more plugins.

### Session Issues

If sessions cause crashes on restore:

```vim
:Autosession delete
```

Sessions are stored in `~/.local/share/nvim/sessions/`.

### Keybinding Conflicts

Use which-key to identify conflicts:
```vim
:WhichKey <leader>
```

Or check health:
```vim
:checkhealth which-key
```

---

## Contributing

If you want to contribute improvements:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

---

## License

MIT License - Feel free to use and modify as needed.

---

## Acknowledgments

- Neovim team for the excellent editor
- Folke for lazy.nvim and many great plugins
- The Neovim community for inspiration and plugins
