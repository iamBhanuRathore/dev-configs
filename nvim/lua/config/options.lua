-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Safe autosave (Option 1): write on :next, :prev, :tag, :make, etc.
-- The actual InsertLeave / BufLeave / FocusLost hook lives in autocmds.lua.
vim.opt.autowrite = true
vim.opt.autowriteall = true

vim.opt.termguicolors = true

-- Detect .env* files as dotenv (nvim has no built-in detection for them).
-- Kept as its own filetype (not sh) so shfmt/shellcheck never touch them.
-- NOTE: no ^/$ anchors here — vim.filetype.add wraps patterns as ^...$
-- itself, and a trailing $ of ours would become a literal "$" and match
-- nothing.
vim.filetype.add({
  filename = { [".env"] = "dotenv" },
  pattern = {
    [".*%.env%.[%w_%.%-]+"] = "dotenv",
    [".*%.env"] = "dotenv",
  },
})

-- Match Antigravity: editor.tabSize 2, prettier.printWidth 200
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Show raw markdown markup (`**`, backticks, …) on every line.
-- LazyVim defaults conceallevel to 2, which hides the markers on idle lines
-- but reveals them on the cursor line (concealcursor is empty) — that's the
-- width "shift" when moving between lines. 0 disables conceal entirely.
vim.opt.conceallevel = 0

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
vim.opt.showbreak = "↪ " -- Marker at the start of wrapped continuation lines
vim.opt.smoothscroll = true -- Scroll by screen lines, not whole logical lines

-- Antigravity-feel scrolling/mouse, all zero-cost built-in options:
-- VS Code-like 2-line wheel (Ghostty/tmux wheel was jumping half-pages
-- via neoscroll's <C-d>/<C-u> mapping), cursor margin so scroll starts
-- early, no layout jump when splitting, fast tty.
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.mousescroll = "ver:2,hor:4"
vim.opt.splitkeep = "screen"
vim.opt.ttyfast = true

-- Long-line safety for wide SQL / generated buffers (keeps VS Code wrap,
-- just caps per-line syntax cost): no highlight past column 300.
vim.opt.synmaxcol = 300
-- 300ms CursorHold delays illuminate/lint slightly vs 200, but avoids
-- swap-write/CursorHold flicker the review flagged. Still snappy.
vim.opt.updatetime = 300
vim.opt.redrawtime = 1500

-- Diagnostic display: virtual_lines reflows the buffer under the cursor on
-- every move (layout shift + flicker while typing). virtual_text is a cheap
-- single-line render with no reflow — smoother and faster. Full message is
-- still available in the float (source + severity shown explicitly).
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●",
  },
  virtual_lines = false,
  float = {
    source = true,
    severity_sort = true,
  },
  severity_sort = true,
})

-- Ensure spaces are not displayed as hyphens when 'list' is enabled
vim.opt.list = true
vim.opt.listchars = "tab:» ,space: ,trail: ,nbsp:%,extends:»,precedes:«"
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

-- Polished font rendering to match reference screenshot (JetBrains Mono).
-- Terminal Neovim (Ghostty/tmux) gets its font from the terminal, but GUI
-- clients (Neovide, nvim-qt, Firenvim) use 'guifont' — keep them in sync.
-- linespace adds 2px breathing room between lines like VS Code/Antigravity.
vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h13.5"
vim.opt.linespace = 2
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_padding_top = 4
  vim.g.neovide_padding_bottom = 4
  vim.g.neovide_padding_left = 8
  vim.g.neovide_padding_right = 8
end

