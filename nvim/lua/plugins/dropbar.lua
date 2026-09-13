-- VS Code / Antigravity-style clickable breadcrumbs (winbar, below tabs).
-- Click a segment with the mouse to open its dropdown (parent dirs,
-- sibling files, symbols), or use <leader>. to fuzzy-pick from keyboard.
-- Folders drill in place; files just open (see config/dropbar-dirs.lua).
local dirs = require("config.dropbar-dirs")

return {
  {
    "Bekaboo/dropbar.nvim",
    event = "LazyFile",
    keys = {
      {
        "<leader>.",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Pick Breadcrumb",
      },
    },
    opts = {
      sources = {
        path = {
          -- No raw `ls` preview panels for folders (files still preview
          -- their code). Dropbar calls this with each entry's path.
          preview = function(path)
            return vim.fn.isdirectory(path) == 0
          end,
        },
      },
    },
    config = function(_, opts)
      local ok_configs, dconfigs = pcall(require, "dropbar.configs")
      local default_on_click = ok_configs and dconfigs.opts.symbol.on_click or nil

      local wrapped -- forward declaration (drill and wrapped reference each other)

      local function drill(entry)
        dirs.drill(entry, wrapped)
      end

      wrapped = function(symbol)
        if type(symbol) == "table" and type(symbol.opts) == "table" then
          if symbol.bar then
            -- Bar segment clicked: menu shows siblings, cursor starts at
            -- sibling_idx, so re-point it at the current file after sorting.
            local siblings = symbol.opts.siblings
            local self_path = dirs.entry_path(symbol)
            if dirs.sort_dirs_first(siblings) and self_path then
              for idx, sib in ipairs(siblings) do
                if dirs.entry_path(sib) == self_path then
                  symbol.opts.sibling_idx = idx
                  break
                end
              end
            end
          elseif symbol.entry then
            -- Menu entry clicked: sub-menu shows children (no index to fix).
            dirs.sort_dirs_first(symbol.opts.children)
          end
        end
        local ret
        if type(default_on_click) == "function" then
          ret = default_on_click(symbol)
        end
        if type(symbol) == "table" then
          dirs.post_process(symbol.menu, drill)
        end
        return ret
      end

      opts.symbol = opts.symbol or {}
      opts.symbol.on_click = wrapped

      require("dropbar").setup(opts)
    end,
  },
}
