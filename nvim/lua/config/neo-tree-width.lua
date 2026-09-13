-- Persists a manually-resized Neo-tree width (e.g. dragged with the mouse).
-- Written by the user_neotree_remember_width autocmds in
-- lua/config/autocmds.lua, read back in lua/plugins/neo-tree.lua.
local M = {}

M.MIN = 15
M.MAX = 100
M.DEFAULT = 40

function M.path()
  return vim.fn.stdpath("data") .. "/neo-tree-width"
end

function M.load()
  local f = io.open(M.path(), "r")
  if not f then
    return nil
  end
  local w = tonumber(f:read("*l") or "")
  f:close()
  if w and w >= M.MIN and w <= M.MAX then
    return math.floor(w)
  end
  return nil
end

function M.save(width)
  if type(width) ~= "number" or width < M.MIN or width > M.MAX then
    return
  end
  local f = io.open(M.path(), "w")
  if f then
    f:write(tostring(math.floor(width)))
    f:close()
  end
end

-- Window id + width of the visible (non-floating) Neo-tree sidebar, if any.
function M.current()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
      if ok and vim.bo[buf].filetype == "neo-tree" then
        return win, vim.api.nvim_win_get_width(win)
      end
    end
  end
  return nil
end

return M
