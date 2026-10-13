return {
  "mfussenegger/nvim-lint",
  opts = {
    -- No InsertLeave: linting mid-typing causes input lag; write + open is
    -- enough. (BufReadPost on giant files is capped by synmaxcol instead —
    -- a per-buffer skip isn't expressible on this spec.)
    events = { "BufWritePost", "BufReadPost" },
    linters_by_ft = {
      -- Use the "*" filetype to run linters on all filetypes.
      -- ['*'] = { 'global linter' },
      -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
      -- ['_'] = { 'fallback linter' },
      -- ["json"] = { "jsonlint" },
      dotenv = { "dotenv_linter" }, -- .env errors as diagnostics
      sh = { "shellcheck" }, -- dev.sh and friends (binary via mason)
      bash = { "shellcheck" },
    },
    linters = {
      dotenv_linter = {
        -- .env files are grouped by section, not alphabetical, so
        -- UnorderedKey would flag nearly every line and bury real issues.
        prepend_args = { "--ignore-checks", "UnorderedKey" },
      },
    },
  },
}
