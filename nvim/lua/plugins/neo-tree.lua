return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "right", -- sidebar on the right (like Antigravity/VS Code)
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
