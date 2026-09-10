-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- LazyVim force-enables spell checking in markdown/text/gitcommit buffers,
-- which paints every name/email/tech term with red "error" underlines that
-- Antigravity/VS Code doesn't show (no built-in spell checker there).
-- Remove it to match. Wrapping is unaffected: user_force_wrap below keeps it.
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")
vim.opt.spell = false

-- Force soft wrap in every non-floating window so long lines always render
-- as multiple visual lines instead of one horizontally-scrollable line.
-- (LazyVim defaults to nowrap and plugins/filetypes can set nowrap locally;
-- this runs last on window enter and wins.)
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("user_force_wrap", { clear = true }),
  callback = function()
    local win = vim.api.nvim_get_current_win()
    -- Skip floating windows (completion menus, hovers, telescope, etc.)
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      return
    end
    vim.wo[win].wrap = true
    vim.wo[win].linebreak = true
    vim.wo[win].breakindent = true
    -- Also keep spell off here (covers buffers opened before VeryLazy,
    -- e.g. `nvim README.md`, where lazyvim_wrap_spell may have fired first).
    vim.wo[win].spell = false
  end,
})
