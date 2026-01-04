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

  -----------------------------------------------------------------------------
  -- 2. THEME & UI
  -----------------------------------------------------------------------------
  {
    "projekt0n/github-nvim-theme",
  },
  { "ellisonleao/gruvbox.nvim" },
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
            -- Add clippy lints for Anchor
            checkOnSave = {
              command = "clippy",
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
    end,
  },

  -----------------------------------------------------------------------------
  -- 5. MASON (Binary Dependencies)
  -----------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "prettierd", -- Faster formatter for Next.js
        "eslint_d", -- Faster linter
        "codelldb", -- Debugger for Rust
        "rustfmt",
      },
    },
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
