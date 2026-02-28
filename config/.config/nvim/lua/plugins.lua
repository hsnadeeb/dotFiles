-- ============================================================================
-- Plugin Manager & Individual Plugin Configs
-- ============================================================================

local function cfg(name)
  return function()
    require("plugins." .. name)()
  end
end

require("lazy").setup({
  -- Core dependency lib
  { "nvim-lua/plenary.nvim", lazy = true },

  -- UI
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = cfg("lualine"),
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = cfg("indent_blankline"),
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = cfg("lspsaga"),
  },

  -- Completion & AI
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "onsails/lspkind-nvim",
    },
    config = cfg("cmp"),
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = cfg("copilot"),
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua", "hrsh7th/nvim-cmp" },
    config = cfg("copilot_cmp"),
  },

  -- Editing tools
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = cfg("autopairs"),
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = cfg("comment"),
  },

  -- Fuzzy finder & search
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    keys = {
      "<leader>ff",
      "<leader>fg",
      "<leader>fb",
      "<leader>fh",
      "<leader>fr",
      "<leader>fk",
      "<leader>fs",
      "<leader>fS",
      "<leader>fd",
      "<leader>fi",
      "<leader>dd",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = cfg("telescope"),
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },
  {
    "windwp/nvim-spectre",
    cmd = "Spectre",
    keys = { "<leader>sw", "<leader>sf", "<leader>sp" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = cfg("spectre"),
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = { "<leader>n", "<leader>e", "<leader>h" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = cfg("nvimtree"),
  },

  -- Syntax & parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- LSP & Mason
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = cfg("mason"),
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
    },
    config = function()
      require("lsp.init").setup()
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = { "<leader>fm" },
    config = cfg("conform"),
  },

  -- Refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    cmd = "Refactor",
    keys = { "<leader>re", "<leader>rf", "<leader>ri", "<leader>reb", "<leader>rp", "<leader>rc" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = cfg("refactoring"),
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = cfg("gitsigns"),
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gs", "<cmd>DiffviewOpen -- %<CR>", desc = "Diff Current File" },
      { "<leader>gS", "<cmd>DiffviewOpen<CR>", desc = "Diff Workspace" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close Diff View" },
      { "<leader>gB", "<cmd>DiffviewFileHistory %<CR>", desc = "File History" },
    },
    config = cfg("diffview"),
  },

  -- Project & sessions
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = cfg("project"),
  },
  {
    "rmagatti/auto-session",
    cmd = { "Autosession", "SessionSave", "SessionRestore" },
    keys = { "<leader>ss", "<leader>sr", "<leader>sd" },
    config = cfg("session"),
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    keys = { "<F5>", "<F10>", "<F11>", "<F12>", "<leader>db", "<leader>dB", "<leader>dc", "<leader>di", "<leader>do", "<leader>dO", "<leader>dr", "<leader>dl", "<leader>du", "<leader>dx" },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = cfg("dap"),
  },

  -- Java support
  { "mfussenegger/nvim-jdtls", ft = "java" },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = { "<leader>tt", "<leader>tf", "<leader>tv", "<leader>th", "<leader>`", "<leader>tg" },
    config = cfg("toggleterm"),
  },

  -- Buffer tabs
  {
    "romgrk/barbar.nvim",
    event = "VeryLazy",
    dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
    config = cfg("barbar"),
  },

  -- Diagnostics
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = { "<leader>xx", "<leader>xw", "<leader>xd", "<leader>xq" },
    config = cfg("trouble"),
  },

  -- Code structure
  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    keys = { "<leader>m" },
    config = cfg("aerial"),
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = cfg("alpha"),
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = cfg("todo_comments"),
  },

  -- Auto-save
  {
    "okuuva/auto-save.nvim",
    event = "VeryLazy",
    config = cfg("autosave"),
  },

  -- Themes
  { "sainnhe/everforest", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },

  -- Neovim Lua DX
  { "folke/neoconf.nvim", cmd = "Neoconf", opts = {} },
  { "folke/lazydev.nvim", ft = "lua" },

  -- Which-key
  {
    "folke/which-key.nvim",
    version = "^1.0.0",
    event = "VimEnter",
    config = cfg("which_key"),
  },
}, {
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "zipPlugin", "netrwPlugin" },
    },
  },
})
