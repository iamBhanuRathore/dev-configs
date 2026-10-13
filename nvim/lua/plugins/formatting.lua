-- Formatting matches Antigravity / VS Code settings:
--   "[typescript]": "vscode.typescript-language-features" (LSP, NOT prettier)
--   "[javascript][typescriptreact][javascriptreact][json]": "prettier-vscode"
--   "prettier.printWidth": 200, "editor.tabSize": 2
--
-- Why: prettier (even with printWidth 200) explodes Elysia-style chains:
--   .get("/", async (...) => { ... }, { ... })
-- into one-arg-per-line. The TS language server (vtsls) keeps them compact
-- exactly like Image 1. Verified with prettier 3.8.3.
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}

    -- Format-on-save budget: 1000ms then skip (no half-written saves).
    -- lsp_fallback only fires when NO conform formatter ran, so prettierd
    -- + fallback can never double-format the same save.
    opts.format = vim.tbl_deep_extend("force", opts.format or {}, {
      timeout_ms = 1000,
      lsp_fallback = true,
    })

    -- Plain `.ts` files: use vtsls (LSP) only, like Antigravity.
    -- Empty list = no conform formatter -> LazyVim falls back to LSP.
    -- This MUST run after lazyvim.plugins.extras.formatting.prettier
    -- (extras.lua loads before formatting.lua alphabetically), so it
    -- overwrites the prettier entry that extra inserts for typescript.
    opts.formatters_by_ft["typescript"] = {}

    -- Other web filetypes: prettierd (daemon, faster than prettier).
    -- NOTE: prettierd caches config; after editing .prettierrc run
    -- `:!prettierd stop` or formatting looks stale.
    opts.formatters_by_ft["javascript"] = { "prettierd" }
    opts.formatters_by_ft["javascriptreact"] = { "prettierd" }
    opts.formatters_by_ft["typescriptreact"] = { "prettierd" }
    opts.formatters_by_ft["json"] = { "prettierd" }
    opts.formatters_by_ft["jsonc"] = { "prettierd" }
    opts.formatters_by_ft["lua"] = { "stylua" }
    opts.formatters_by_ft["rust"] = { "rustfmt" }
    opts.formatters_by_ft["sh"] = { "shfmt" }
    opts.formatters_by_ft["bash"] = { "shfmt" }

    opts.formatters = opts.formatters or {}

    -- Antigravity global fallback: printWidth 200, tabWidth 2.
    -- If the project HAS its own prettier config, respect it (like VS Code
    -- does: .prettierrc wins over editor settings). Otherwise apply the
    -- Antigravity globals so we don't fall back to prettier's 80-col default.
    -- Shared by prettier + prettierd (same CLI flags).
    local prettier_fallback_args = function(_, ctx)
          local config_files = {
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.json5",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            ".prettierrc.toml",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
          }
          local found = vim.fs.find(config_files, {
            upward = true,
            path = ctx and ctx.dirname or vim.fn.expand("%:p:h"),
          })[1]
          -- Also respect "prettier" key in package.json
          if not found then
            local pkg = vim.fs.find("package.json", {
              upward = true,
              path = ctx and ctx.dirname or vim.fn.expand("%:p:h"),
            })[1]
            if pkg then
              local ok, content = pcall(vim.fn.readfile, pkg)
              if ok and content then
                local text = table.concat(content, "\n")
                if text:find('"prettier"%s*:') then
                  found = pkg
                end
              end
            end
          end
          if found then
            return {}
          end
          return {
            "--print-width",
            "200",
            "--tab-width",
            "2",
            "--use-tabs",
            "false",
            "--semi",
            "true",
            "--end-of-line",
            "auto",
          }
        end
    for _, name in ipairs({ "prettier", "prettierd" }) do
      opts.formatters[name] = vim.tbl_deep_extend("force", opts.formatters[name] or {}, {
        prepend_args = prettier_fallback_args,
      })
    end

    opts.formatters["rustfmt"] = vim.tbl_deep_extend("force", opts.formatters["rustfmt"] or {}, {
      prepend_args = { "--edition", "2021" },
    })

    -- shfmt defaults to tabs; this repo uses 2 spaces (see scripts/dev.sh).
    opts.formatters["shfmt"] = vim.tbl_deep_extend("force", opts.formatters["shfmt"] or {}, {
      prepend_args = { "-i", "2" },
    })
  end,
}
