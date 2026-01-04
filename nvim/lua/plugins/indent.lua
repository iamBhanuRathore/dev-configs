return {
  -- Disable snacks.indent (static indentation guides)
  {
    "folke/snacks.nvim",
    opts = {
      indent = { enabled = false },
    },
  },

  -- Enable mini.indentscope (only highlights the active scope)
  {
    "nvim-mini/mini.indentscope",
    version = false, -- wait till new release
    event = "LazyFile",
    opts = {
      -- symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
