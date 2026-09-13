local neotree_width = require("config.neo-tree-width")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    },
    opts = {
      -- Keep the cursor on the first letter of the filename when moving.
      -- Otherwise j/k preserves a deep column and Vim sidescrolls to keep
      -- the cursor visible, hiding the indent + first letters of names.
      enable_cursor_hijack = true,
      window = {
        position = "right", -- sidebar on the right (like Antigravity/VS Code)
        -- Last manually-resized width if there is one, else the default.
        -- Fixed: never auto-grow, long names cut on the right.
        width = neotree_width.load() or neotree_width.DEFAULT,
        auto_expand_width = false, -- don't resize when a filename exceeds the width
      },
      event_handlers = {
        {
          -- Toggle/restart recreates the window from opts, forgetting a
          -- manual drag-resize done after setup. Re-apply the saved width.
          event = "neo_tree_window_after_open",
          handler = function(args)
            local saved = neotree_width.load()
            if not saved or not args or not args.winid then
              return
            end
            if vim.api.nvim_win_is_valid(args.winid) then
              pcall(vim.api.nvim_win_set_width, args.winid, saved)
            end
          end,
        },
      },
      filesystem = {
        filtered_items = {
          always_show = {
            ".env",
          },
        },
      },
    },
  },
}
