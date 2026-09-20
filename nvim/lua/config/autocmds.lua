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
    -- Neo-tree manages its own window options (nowrap + pinned left, see below).
    if vim.bo.filetype == "neo-tree" then
      return
    end
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

-- Neo-tree renders one file per line with nowrap (upstream default) and
-- right-aligns git/diagnostic symbols. Lines longer than the window make Vim
-- sidescroll, hiding the indent + first letters of every name ("modules"
-- shows as "odules"). A file tree never needs horizontal scrolling, so keep
-- it nowrap and pin the view to the left.
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("user_neotree_nowrap", { clear = true }),
  callback = function()
    if vim.bo.filetype ~= "neo-tree" then
      return
    end
    local win = vim.api.nvim_get_current_win()
    vim.wo[win].wrap = false
    vim.wo[win].sidescrolloff = 0
    -- NOTE: 'sidescroll' is global-only, it can't be set per window.
    -- Keep the tree out of `wincmd =` equalizing so splits never squash it
    -- (which would also pollute the remembered manual width below).
    vim.wo[win].winfixwidth = true
  end,
})

-- Keep the tree pinned to the left: reset any horizontal offset in the
-- Neo-tree window itself (not just the current window, so wheel-scrolling
-- the tree while focused elsewhere is corrected too). The cursor is pulled
-- to column 0 only when it sits past the visible edge — otherwise Vim would
-- immediately sidescroll again to keep it visible, which is what made the
-- pinning "not stick". Acting only when leftcol ~= 0 keeps this a no-op
-- most of the time.
vim.api.nvim_create_autocmd({ "CursorMoved", "WinScrolled", "WinEnter", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("user_neotree_pin_left", { clear = true }),
  callback = function(ev)
    local neotree_width = require("config.neo-tree-width")
    local win
    if ev.event == "WinScrolled" then
      -- A scroll can target a non-focused window (e.g. mouse wheel over
      -- the tree while typing elsewhere), so scan for the tree window.
      win = neotree_width.current()
      if not win then
        return
      end
    else
      -- Fast path: these events only ever affect the current window, so a
      -- single filetype check avoids scanning all windows on every move.
      if vim.bo.filetype ~= "neo-tree" then
        return
      end
      win = vim.api.nvim_get_current_win()
    end
    local view = vim.api.nvim_win_call(win, vim.fn.winsaveview)
    if view.leftcol == 0 then
      return
    end
    view.leftcol = 0
    if view.col >= vim.api.nvim_win_get_width(win) and vim.api.nvim_get_mode().mode == "n" then
      view.col = 0
    end
    vim.api.nvim_win_call(win, function()
      vim.fn.winrestview(view)
    end)
  end,
})

-- Give the breadcrumb (winbar) row its own background band so it reads as
-- a separate strip from the tabs above and the code below. Terminal rows
-- are a fixed cell height, so true top/bottom padding inside the row isn't
-- possible -- this separation is the closest equivalent.
local function apply_winbar_band()
  -- Subtle lift: Normal bg mixed 12% toward fg (VS Code breadcrumb feel).
  -- Falls back to the StatusLine band when Normal is transparent.
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if normal.bg then
    local fg = normal.fg or 0xffffff
    local r = math.floor((((normal.bg / 0x10000) % 0x100) * 0.88 + ((fg / 0x10000) % 0x100) * 0.12) + 0.5)
    local g = math.floor((((normal.bg / 0x100) % 0x100) * 0.88 + ((fg / 0x100) % 0x100) * 0.12) + 0.5)
    local b = math.floor((((normal.bg) % 0x100) * 0.88 + ((fg) % 0x100) * 0.12) + 0.5)
    local band = r * 0x10000 + g * 0x100 + b
    vim.api.nvim_set_hl(0, "WinBar", { bg = band })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = band })
  else
    vim.api.nvim_set_hl(0, "WinBar", { link = "StatusLine" })
    vim.api.nvim_set_hl(0, "WinBarNC", { link = "StatusLineNC" })
  end
end
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("user_winbar_band", { clear = true }),
  callback = apply_winbar_band,
})
apply_winbar_band()

-- Safe autosave (Option 1, Antigravity-like without save-on-every-keystroke):
-- save when leaving insert mode, switching buffers, or focusing another app.
vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "FocusLost" }, {
  group = vim.api.nvim_create_augroup("user_autosave", { clear = true }),
  callback = function()
    if vim.bo.modifiable and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.cmd("silent! update")
    end
  end,
})

-- Remember a manual (mouse/cursor-drag) resize of the Neo-tree sidebar so the
-- same width is restored on toggle/restart (see lua/plugins/neo-tree.lua).
-- winfixwidth above keeps splits from squashing the tree, so a width change
-- here almost always means a deliberate drag.
vim.api.nvim_create_autocmd({ "WinResized", "VimLeavePre" }, {
  group = vim.api.nvim_create_augroup("user_neotree_remember_width", { clear = true }),
  callback = function()
    local neotree_width = require("config.neo-tree-width")
    local _, w = neotree_width.current()
    if w then
      neotree_width.save(w)
    end
  end,
})
