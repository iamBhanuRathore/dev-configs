-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Select all with Ctrl+a
vim.keymap.set({ "n", "i" }, "<C-a>", "<cmd>normal! ggVG<cr>", { desc = "Select All" })

-- Ctrl+z suspends Neovim (drops you back to the shell looking like it
-- "closed"). VS Code / Antigravity users expect Undo instead, so disable
-- the suspend key and give them Undo. Terminal mode is left alone so
-- job-control (suspend foreground job, `fg` to resume) still works.
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo (disable suspend)" })
vim.keymap.set("v", "<C-z>", "u", { desc = "Undo (disable suspend)" })
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo (disable suspend)" })

-- Save everywhere (VS Code muscle memory; idempotent if LazyVim maps it).
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Git: lazygit UI + current-line blame. <leader>gg is free (lazygit extra
-- not imported); blame via gitsigns (LazyVim default plugin).
vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gB", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame Line (full)" })

-- Diagnostics float for the current line (<leader>cd exists in LazyVim;
-- this keeps the same behavior with source shown, per options.lua).
vim.keymap.set("n", "<leader>cD", function()
  vim.diagnostic.open_float({ source = true })
end, { desc = "Line Diagnostics (source)" })