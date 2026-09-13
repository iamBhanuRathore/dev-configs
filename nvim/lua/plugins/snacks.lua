return {
  {
    "folke/snacks.nvim",
    keys = {
      -- VS Code Ctrl+P: open buffers first, then recent files, then all
      -- files, deduplicated. Empty query shows MRU instead of disk order.
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
    },
    opts = {
      picker = {
        matcher = {
          -- Rank files you actually use first (VS Code Ctrl+P behavior):
          -- frequently/recently opened files float above stale matches,
          -- and an empty query lists recent files instead of raw disk order.
          frecency = true,
          history_bonus = true,
          sort_empty = true,
        },
      },
    },
  },
}
