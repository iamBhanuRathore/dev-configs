-- Completion: blink.cmp menu-only (no tab-AI / ghost text).
-- Replaces the old nvim-cmp + disabled cmp-ai stack: blink is the LazyVim
-- default and notably faster (Rust core). <C-Space> still forces the menu.
return {
  {
    "saghen/blink.cmp",
    enabled = true,
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
