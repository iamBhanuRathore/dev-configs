return {
  "mfussenegger/nvim-lint",
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      -- Use the "*" filetype to run linters on all filetypes.
      -- ['*'] = { 'global linter' },
      -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
      -- ['_'] = { 'fallback linter' },
      -- ["json"] = { "jsonlint" },
      dotenv = { "dotenv_linter" }, -- .env errors as diagnostics
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
