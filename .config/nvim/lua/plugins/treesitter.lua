---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed then
        vim.list_extend(opts.ensure_installed, { "helm" })
      else
        opts.ensure_installed = { "helm" }
      end
    end,
  },
}
