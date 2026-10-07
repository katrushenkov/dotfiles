-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  desc = "SetEnglishLayout",
  callback = function()
    vim.fn.system(vim.fn.expand("$HOME/.local/bin/hypr-switch-en"))
  end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "*",
  desc = "SetEnglishLayout",
  callback = function()
    vim.fn.system(vim.fn.expand("$HOME/.local/bin/hypr-switch-en"))
  end,
})

-- Distinct colors for markdown headings H1-H6 (themes like gruvbox don't define
-- @markup.heading.N, so all levels fall back to Title). Colors are taken from
-- the current theme's syntax groups, so it works across omarchy theme switches.
local function set_markdown_heading_colors()
  local groups = { "@keyword", "@function", "@type", "@number", "@operator", "@comment" }
  for i, g in ipairs(groups) do
    local fg = vim.api.nvim_get_hl(0, { name = g, link = false }).fg
    vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", { fg = fg, bold = true })
  end
end
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "MarkdownHeadingColors",
  callback = set_markdown_heading_colors,
})
-- autocmds.lua loads on VeryLazy, after the colorscheme is already applied
set_markdown_heading_colors()
