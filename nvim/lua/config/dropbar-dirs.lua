-- VS Code-style directory behavior for dropbar.nvim breadcrumb menus:
-- folders-first sorting, plus drill-into-folder instead of `:edit`ing a
-- directory (editing one pops the extra Snacks explorer sidebar).
--
-- Coupled to dropbar internals (symbol.opts.{siblings,children},
-- menu.entries/components, component.entry backlinks). Every access is
-- guarded so a future dropbar change degrades to stock behavior instead
-- of breaking clicks.
local M = {}

---Full path of a path-source symbol, or nil (LSP/treesitter symbols, etc).
---@param sym table
---@return string?
function M.entry_path(sym)
  local ok, path = pcall(function()
    return sym.opts.data.path
  end)
  if ok and type(path) == "string" then
    return path
  end
  return nil
end

---@param sym table
---@return boolean
function M.is_dir(sym)
  local path = M.entry_path(sym)
  if not path then
    return false
  end
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil and stat.type == "directory"
end

---Sort entries in place: directories first, then files, alphabetical
---(case-insensitive) within each group. Returns false (untouched) for
---empty or non-path lists such as LSP/treesitter symbol menus.
---@param entries table?
---@return boolean sorted
function M.sort_dirs_first(entries)
  if type(entries) ~= "table" or #entries == 0 then
    return false
  end
  if not M.entry_path(entries[1]) then
    return false
  end
  table.sort(entries, function(a, b)
    local ad, bd = M.is_dir(a), M.is_dir(b)
    if ad ~= bd then
      return ad
    end
    local an = vim.trim(a.name or ""):lower()
    local bn = vim.trim(b.name or ""):lower()
    if an == bn then
      return (a.name or "") < (b.name or "")
    end
    return an < bn
  end)
  return true
end

---Rewrite directory rows of an open menu so activating them drills into a
---submenu instead of `:edit`ing the directory. `drill` is invoked with the
---entry when such a row is activated. Files/symbols are untouched, so
---clicking a file still just opens it. Closed/nil menus are skipped.
---@param menu table?
---@param drill fun(entry: table)
function M.post_process(menu, drill)
  if type(menu) ~= "table" or not menu.is_opened or type(menu.entries) ~= "table" then
    return
  end
  for _, e in ipairs(menu.entries) do
    local comps = e.components
    if type(comps) == "table" and #comps > 0 then
      local dir_row = false
      for _, c in ipairs(comps) do
        if M.entry_path(c) then
          dir_row = M.is_dir(c)
          break
        end
      end
      if dir_row then
        -- Last clickable component is the name (jump-opener); the
        -- indicator keeps its stock submenu toggle.
        for i = #comps, 1, -1 do
          if comps[i].on_click then
            local entry = e
            comps[i].on_click = function()
              drill(entry)
            end
            break
          end
        end
      end
    end
  end
end

---Drill into a folder: route through the entry's indicator component
---(whose click opens the submenu) with its backlink set. `click` is
---dropbar's click handler (opts.symbol.on_click).
---@param entry table
---@param click fun(sym: table)?
function M.drill(entry, click)
  local comps = entry.components
  local ind = type(comps) == "table" and comps[1] or nil
  if ind == nil or type(click) ~= "function" then
    return
  end
  ind.entry = entry
  click(ind)
end

return M
