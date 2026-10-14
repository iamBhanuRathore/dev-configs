-- Every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
return {
  -----------------------------------------------------------------------------
  -- 1. LANGUAGE EXTRAS (Batteries Included)
  -- LazyVim extras handle LSP, Treesitter, and Tooling setup automatically
  -----------------------------------------------------------------------------
  { import = "lazyvim.plugins.extras.lang.typescript" }, -- TS/JS/Next.js
  { import = "lazyvim.plugins.extras.lang.rust" }, -- Rust/Anchor
  { import = "lazyvim.plugins.extras.lang.tailwind" }, -- Next.js Styling
  { import = "lazyvim.plugins.extras.lang.json" }, -- Config files/IDLs
  { import = "lazyvim.plugins.extras.lang.prisma" }, -- Database ORM
  { import = "lazyvim.plugins.extras.lang.docker" }, -- Containers
  { import = "lazyvim.plugins.extras.lang.yaml" }, -- K8s/Actions
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.linting.eslint" },
  { import = "lazyvim.plugins.extras.ui.treesitter-context" }, -- VS Code sticky scroll

  -----------------------------------------------------------------------------
  -- 1b. DEBUG & TEST (DAP + neotest; adapters in lua/plugins/dap.lua etc.)
  -----------------------------------------------------------------------------
  { import = "lazyvim.plugins.extras.dap.core" }, -- <leader>d... debugging
  { import = "lazyvim.plugins.extras.test.core" }, -- <leader>t... tests

  -----------------------------------------------------------------------------
  -- 2. THEME & UI
  -----------------------------------------------------------------------------
  {
    "projekt0n/github-nvim-theme",
  },
  -- NOTE: gruvbox.nvim removed (unused; github_dark_dimmed is the theme).
  -- catppuccin stays only as lazy-loaded fallback via theme.lua integrations.
  {
    "LazyVim/LazyVim",
    opts = {
      -- Change this to "github_dark_dimmed" for a more muted IDX-like feel
      -- colorscheme = "github_dark_dimmed",
    },
  },
  -----------------------------------------------------------------------------
  -- 3. LSP & TOOLING CUSTOMIZATION (Web3 & Rust)
  -----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Anchor/Solana uses Cargo.toml and TOML heavily
        taplo = {},
        -- Explicitly disable rust_analyzer in lspconfig 
        -- to prevent conflicts with rustaceanvim
        rust_analyzer = { enabled = false },
        -- eslint: flat config + monorepo-aware working directories so it
        -- lints the nearest package instead of walking the whole monorepo.
        eslint = {
          settings = {
            useFlatConfig = true,
            workingDirectories = { mode = "auto" },
          },
        },
        -- NOTE: tailwindcss left at extra defaults on purpose. It only
        -- attaches where tailwind/postcss config exists (apps/web), so
        -- backend pays registration cost only, not a live server.
      },
      inlay_hints = { enabled = false },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>rc", "<cmd>Rustacean cargo check<cr>", { buffer = bufnr, desc = "Cargo Check" })
          vim.keymap.set("n", "<leader>rt", "<cmd>Rustacean cargo test<cr>", { buffer = bufnr, desc = "Cargo Test" })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Check on save uses plain `cargo check` (fast diagnostics).
            -- Clippy stays MANUAL via <leader>rc: clippy on Anchor proc
            -- macros is slow enough to stutter saves. rust-analyzer check
            -- already surfaces most issues; run clippy on demand.
            checkOnSave = {
              command = "check",
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- 4. TREESITTER (Syntax Highlighting)
  -----------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "rust",
        "toml",
        "tsx",
        "typescript",
        "prisma",
        "graphql", -- Useful for Web3 indexing
        "solidity", -- Useful if you bridge to EVM
        "sql",
      })
      -- No vim-regex fallback highlighting (keeps all 8 parsers, halves
      -- highlight work on wide SQL lines; synmaxcol caps the rest).
      opts.highlight = vim.tbl_deep_extend("force", opts.highlight or {}, {
        enable = true,
        additional_vim_regex_highlighting = false,
      })
      opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, { enable = true })
    end,
  },

  -----------------------------------------------------------------------------
  -- 5. MASON (Binary Dependencies)
  -----------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "prettierd", -- Faster formatter for Next.js
        "rustfmt",
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- 6. KEYMAPS (Telescope Plugin Search)
  -----------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
    },
  },
}
