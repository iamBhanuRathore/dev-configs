-- Debug adapters. Core UI + keys come from lazyvim.plugins.extras.dap.core
-- (imported in example.lua). Rust/codelldb is auto-wired by the rust extra
-- + rustaceanvim, so only JS/TS needs manual setup here.
-- NOTE: no `config()` on purpose -- dap.core owns it. This only registers
-- the adapter table, once, on the first JS/TS buffer.
return {
  {
    "mfussenegger/nvim-dap",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        once = true,
        group = vim.api.nvim_create_augroup("user_dap_js", { clear = true }),
        callback = function()
          local ok, dap = pcall(require, "dap")
          if not ok or dap.adapters["pwa-node"] then
            return
          end
          if vim.fn.executable("node") == 0 then
            vim.notify("nvim-dap: `node` not found, JS/TS debugging disabled", vim.log.levels.WARN)
            return
          end
          local js_debug =
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
          if vim.fn.filereadable(js_debug) == 0 then
            vim.notify("nvim-dap: js-debug not installed (:MasonInstall js-debug-adapter)", vim.log.levels.WARN)
            return
          end
          dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = { command = "node", args = { js_debug, "${port}" } },
          }
          for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
            dap.configurations[lang] = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch current file (node)",
                program = "${file}",
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                skipFiles = { "<node_internals>/**", "node_modules/**" },
              },
              {
                type = "pwa-node",
                request = "attach",
                name = "Attach to process",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
                sourceMaps = true,
              },
            }
          end
        end,
      })
    end,
  },
}
