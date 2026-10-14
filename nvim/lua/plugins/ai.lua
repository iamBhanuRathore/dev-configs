-- Completion: blink.cmp menu-only (no tab-AI / ghost text).
-- Replaces the old nvim-cmp + disabled cmp-ai stack: blink is the LazyVim
-- default and notably faster (Rust core). <C-Space> still forces the menu.
return {
  {
    "saghen/blink.cmp",
    enabled = true,
    -- Pinned to v1: v2 requires nvim 0.12+ and this machine runs 0.11.
    -- Drop the pin after upgrading neovim.
    version = "1.*",
    opts = {
      completion = {
        ghost_text = { enabled = false },
        menu = { auto_show = true },
      },
      keymap = {
        preset = "default",
        ["<C-Space>"] = { "show", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
