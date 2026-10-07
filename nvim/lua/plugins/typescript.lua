-- vtsls tuning for large Bun monorepos (trello/boardly: backend + dashboard +
-- super-admin + mobile in one workspace).
--
-- Why this exists: vtsls defaults `typescript.tsserver.maxTsServerMemory` to
-- ~3GB (VSCode default). A single vtsls instance loads *all* tsconfigs in the
-- monorepo at once (backend references dashboard via @boardly/backend paths
-- and vice versa), OOMs, and tsserver exits with SIGABRT. Every `gd` after
-- that fails until the server restarts, then it crashes again:
--   "TSServer exited. Code: null. Signal: SIGABRT" in :LspLog
--   "The JS/TS language service crashed 5 times in the last 5 Minutes."
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      vtsls = {
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
            -- The actual crash fix: raise the heap limit (MB) and run a
            -- single tsserver instead of semantic + syntax pair.
            tsserver = {
              maxTsServerMemory = 8192,
              useSeparateSyntaxServer = false,
            },
            -- Large workspace: don't scan every package.json for auto-imports.
            -- Relative imports + explicit paths still complete fine.
            preferences = {
              includePackageJsonAutoImports = "off",
              includeCompletionsForModuleExports = false,
            },
          },
        },
      },
    },
  },
}
