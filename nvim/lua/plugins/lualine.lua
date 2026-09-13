return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- LazyVim's pretty_path collapses long paths to `first/…/last-2`
      -- (length = 3). Show the full relative path instead so deep files
      -- stay readable. Set length to e.g. 5 to re-cap it.
      for i, comp in ipairs(opts.sections.lualine_c or {}) do
        -- The path component is a bare single-function list; root_dir and
        -- trouble symbols also hold functions but always carry `cond`.
        if type(comp) == "table" and type(comp[1]) == "function" and comp[2] == nil and comp.cond == nil then
          opts.sections.lualine_c[i] = { LazyVim.lualine.pretty_path({ length = 0 }) }
        end
      end
    end,
  },
}
