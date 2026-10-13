return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "LazyFile",
    -- NOTE: no per-buffer cond here (lazy.nvim cond gets a plugin spec, not
    -- a buffer). Giant-buffer cost is capped by synmaxcol + snacks.bigfile.
  },
}
