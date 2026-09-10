return {
  -- ToggleTerm: Better terminal management (like VS Code's terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[<c-/>]], -- Ctrl+/ to toggle terminal (changed from Ctrl+\ to avoid conflict)
      direction = "float",
      float_opts = {
        border = "curved",
      },
    },
  },

  -- Disable Noice to restore standard cmdline behavior
  {
    "folke/noice.nvim",
    enabled = false,
  },

  -- Todo Comments: Highlight TODO, FIXME, BUG, etc. in comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- configuration options
    },
    event = "BufReadPost",
  },

  -- Symbols Outline: A sidebar to see code structure (classes, functions)
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- Trouble: Better diagnostics list (errors, warnings)
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    },
  },

  -- Mason: Ensure common tools are installed automatically
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua", -- Lua formatter
        "prettier", -- Web formatter
        "eslint_d", -- JS linter
        "shellcheck", -- Shell linter
        "shfmt", -- Shell formatter
        "json-lsp", -- JSON Language Server
        "html-lsp", -- HTML Language Server
        "css-lsp", -- CSS Language Server
        "typescript-language-server", -- TS/JS Language Server
        -- Rust specific tools
        "rust-analyzer", -- Rust LSP
        "codelldb", -- Debugger for Rust and C/C++
        "taplo", -- TOML LSP
      })
    end,
  },

  -- Seamless navigation between Tmux panes and Vim splits
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate Left" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate Down" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate Up" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate Right" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate Previous" },
    },
  },

  -- Neoscroll: Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "WinScrolled", -- Only load when scrolling occurs
    opts = {
      hide_cursor = true,
      stop_scroll = true,
      easing = "exponential",
      scroll_down_mouse = { 'v:count == 0 ? "<c-d>" : "<c-d>"' },
      scroll_up_mouse = { 'v:count == 0 ? "<c-u>" : "<c-u>"' },
      scroll_down = { "<c-d>", "<c-f>" },
      scroll_up = { "<c-u>", "<c-b>" },
      -- Other options for custom keybindings can be added here
      -- For example, to bind `s` for smoother down, `w` for smoother up:
      -- scroll_down = { "<c-d>", "s" },
      -- scroll_up = { "<c-u>", "w" },
    },
    config = function(_, opts)
      require("neoscroll").setup(opts)
    end,
  },
}

