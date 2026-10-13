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
      -- Genuine gaps (LazyVim core covers <space>, `,` and `/`; these match
      -- VS Code muscle memory and don't clash with existing maps).
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep Workspace",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Find Buffers",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent Files",
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
      -- Antigravity-like smooth scrolling without a new plugin.
      -- snacks.scroll is cheaper than neoscroll.nvim: pure redraw timing,
      -- no cursor hiding, auto-disabled on big files. Duration kept short
      -- so it feels snappy, not floaty.
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 12, total = 120 },
          easing = "outExpo",
        },
      },
      -- Zero-cost DX: bigfile disables heavy features (indent, scroll
      -- animation, lint) in giant buffers; quickfile renders macros fast;
      -- words adds VS Code-like ]]/[[ reference jumps.
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
    },
  },
}
