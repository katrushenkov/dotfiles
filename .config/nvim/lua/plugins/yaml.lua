-- YAML: LSP/schemas/helm come from LazyVim extras (lang.yaml, lang.helm in lazyvim.json);
-- here only linter and formatter.
return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "yamllint", "yamlfmt" } },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = { yaml = { "yamllint" } },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { yaml = { "yamlfmt" } },
      formatters = {
        -- by default yamlfmt drops blank lines between blocks; keep them
        -- (a project-level .yamlfmt still applies for other settings)
        yamlfmt = { prepend_args = { "-formatter", "retain_line_breaks_single=true" } },
      },
    },
  },
}
