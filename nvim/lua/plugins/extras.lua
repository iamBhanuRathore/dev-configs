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

  -- Noice enabled (LazyVim stock): routes cmdline/messages to popups so
  -- cmdheight=0 works with no gap and no "Press ENTER" confirmations.

  -- Todo Comments: Highlight TODO, FIXME, BUG, etc. in comments.
  -- LazyFile (not BufReadPost) so it loads after UI; giant-buffer cost is
  -- capped separately by synmaxcol + snacks.bigfile (see options/snacks).
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    event = "LazyFile",
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
        "dotenv-linter", -- .env linter (UnorderedKey excluded in linting.lua)
        "json-lsp", -- JSON Language Server
        "html-lsp", -- HTML Language Server
        "css-lsp", -- CSS Language Server
        "vtsls", -- TS/JS Language Server (LazyVim typescript extra uses vtsls)
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

  -- Smooth scrolling is handled by snacks.scroll (see snacks.lua).
  -- neoscroll.nvim was removed: it mapped the mouse wheel to <C-d>/<C-u>
  -- (half-page jumps with hide_cursor), fought built-in smoothscroll, and
  -- loaded lazily on WinScrolled which made the first scroll jank.
}

