return {
  { "saghen/blink.cmp", enabled = false },
  {
    'tzachar/cmp-ai',
    enabled = false, -- Disabled temporarily to fix startup crash
    dependencies = { 'nvim-lua/plenary.nvim', 'hrsh7th/nvim-cmp' },
    config = function()
      local cmp_ai = require('cmp_ai.config')
      cmp_ai:setup({
        max_lines = 1000,
        provider = 'Google',
        provider_options = {
          model = 'gemini-2.5-flash',
        },
        notify = true,
        notify_callback = function(msg) vim.notify(msg) end,
        run_on_every_keystroke = true,
        ignored_file_types = {
          -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        },
      })
    end
  },
  {
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      -- Force Ctrl+Space to trigger completion
      local cmp = require("cmp")
      opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
        ["<C-Space>"] = cmp.mapping.complete(),
      })

      -- Customize 'path' source options in the existing list
      for _, source in ipairs(opts.sources) do
        if source.name == "path" then
          source.option = { trailing_slash = true }
        end
      end
    end,
  },
}
