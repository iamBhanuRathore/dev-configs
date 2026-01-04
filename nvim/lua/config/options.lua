-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.termguicolors = true

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

