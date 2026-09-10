-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.termguicolors = true

-- Match Antigravity: editor.tabSize 2, prettier.printWidth 200
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Hide the empty command-line row (cmdheight 0). Default is 1, which leaves
-- a permanent blank line between lualine and the tmux status bar. With 0 the
-- cmdline only pops up when actually used (:, /, ?). Needs restart to apply.
vim.opt.cmdheight = 0

-- Antigravity uses vscode.typescript-language-features for [typescript],
-- NOT eslint fix-on-save. Disable eslint as a formatter so it can't
-- reflow code differently from vtsls/prettier.
vim.g.lazyvim_eslint_auto_format = false
-- Run prettier even when the project has no prettier config
-- (formatting.lua supplies the printWidth-200 fallback in that case).
vim.g.lazyvim_prettier_needs_config = false

-- VS Code-like Soft Wrapping
vim.opt.wrap = true -- Enable soft wrapping
vim.opt.linebreak = true -- Wrap at words, not characters
vim.opt.breakindent = true -- Wrapped lines maintain visual indentation
vim.opt.breakindentopt = "shift:2" -- Optional: Indent wrapped lines slightly more for clarity

-- Wrap diagnostic messages in float and virtual text
vim.diagnostic.config({
  float = {
    wrap = true,
  },
  virtual_text = {
    wrap = true,
  },
})

-- Ensure spaces are not displayed as hyphens when 'list' is enabled
vim.opt.list = true
vim.opt.listchars = "tab:» ,space: ,trail: ,nbsp:%,extends:»,precedes:«"
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

