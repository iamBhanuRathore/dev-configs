return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- Match Antigravity: workbench.colorTheme "GitHub Dark Dimmed"
      colorscheme = "github_dark_dimmed",
    },
  },
  {
    -- JSX/TSX token colors to match Antigravity (VS Code semantic style):
    -- component/tag names red, attributes blue, delimiters grey.
    -- Without this, delimiters link through an undefined group and blend
    -- into the foreground. Hexes are official Primer dimmed values.
    "projekt0n/github-nvim-theme",
    opts = {
      groups = {
        all = {
          ["@tag"] = { fg = "#ff7b72" },
          ["@tag.builtin"] = { fg = "#ff7b72" },
          ["@tag.tsx"] = { fg = "#ff7b72" },
          ["@tag.javascript"] = { fg = "#ff7b72" },
          ["@tag.attribute"] = { fg = "#79c0ff" },
          ["@tag.attribute.tsx"] = { fg = "#79c0ff" },
          ["@tag.attribute.javascript"] = { fg = "#79c0ff" },
          ["@tag.delimiter"] = { link = "Comment" },
          ["@tag.delimiter.tsx"] = { link = "Comment" },
          ["@tag.delimiter.javascript"] = { link = "Comment" },
        },
      },
    },
  },
  -- VS Code Material-style file icons (Antigravity uses material-icon-theme).
  -- mini.icons stays as fallback; devicons takes precedence when present.
  { "nvim-tree/nvim-web-devicons", lazy = true },
}

