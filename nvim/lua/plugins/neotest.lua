-- Test adapters. Core UI + <leader>t keys come from
-- lazyvim.plugins.extras.test.core (imported in example.lua); Rust is
-- auto-wired by the rust extra (rustaceanvim.neotest). Bun needs this.
return {
  {
    "nvim-neotest/neotest",
    dependencies = { "jutonz/neotest-bun" },
    opts = {
      adapters = {
        "neotest-bun", -- `bun test` (backend, mobile)
      },
    },
  },
}
