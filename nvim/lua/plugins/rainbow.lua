return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
    -- Skip big files (same guard as todo-comments): rainbow matching walks
    -- the whole treesitter tree, which stings on giant SQL/generated files.
    cond = function(buf)
      return not vim.b[buf or vim.api.nvim_get_current_buf()].bigfile
    end,
  },
}
