local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Disable the LazyVim import order check to resolve the error
vim.g.lazyvim_check_order = false

require("lazy").setup({
  spec = {
    -- 1. Load LazyVim core
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- 2. Load LazyVim extras
    -- (linting.eslint lives in lua/plugins/example.lua with the other extras)
    { import = "lazyvim.plugins.extras.coding.nvim-cmp" },
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- TIP: For your Rust work, you might want to add:
    -- { import = "lazyvim.plugins.extras.lang.rust" },

    -- 3. Load your personal plugin overrides (from lua/plugins/)
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight" } },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
