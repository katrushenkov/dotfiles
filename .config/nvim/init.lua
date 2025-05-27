-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  vim.api.nvim_echo(
    { { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } },
    true,
    {}
  )
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

require "mappings"

-- -- local project_actions = require "telescope._extensions.project.actions"
-- require("telescope").setup {
--   defaults = {
--       find_command = {
--           "rg",
--           "--no-heading",
--           "--with-filename",
--           "--line-number",
--           "--column",
--           "--smart-case",
--       },
--   },
--   extensions = {
--     -- fzf = {
--     --   fuzzy = true, -- false will only do exact matching
--     --   override_generic_sorter = true, -- override the generic sorter
--     --   override_file_sorter = true,    -- override the file sorter
--     --   case_mode = "ignore_case",      -- "respect_case"
--     -- },
--      -- menu = {
--      --    default = {
--      --      items = {
--      --        -- You can add an item of menu in the form of { "<display>", "<command>" }
--      --        { "Checkhealth", "checkhealth" },
--      --        { "Show LSP Info", "LspInfo" },
--      --        { "Files", "Telescope find_files" },
--      --
--      --        -- The above examples are syntax-sugars of the following;
--      --        { display = "Change colorscheme", value = "Telescope colorscheme" },
--      --      },
--      --    },
--      -- },
--     -- project = {
--     --   base_dirs = {
--     --     { path = "~/.local/src", max_depth = 2 },
--     --     --{ "~/.local/src/datagrip" },
--     --     --{ "~/.local/src" },
--     --   },
--     --   theme = "dropdown",
--     --   order_by = "recent",
--     --   sync_with_nvim_tree = true,
--     --   search_by = "title",
--     --   hidden_files = true,
--     --   on_project_selected = function(prompt_bufnr)
--     --     project_actions.change_working_directory(prompt_bufnr)
--     --   end,
--     --   --on_project_selected = function(prompt_bufnr) _actions.find_project_files(prompt_bufnr, hidden_files) end,
--     -- },
--   },
--   pickers = {
--     find_files = {
--       theme = "ivy", --dropdown
--       hidden_files = true,
--       hidden = true,
--       no_ignore = true,
--       no_ignore_parent = true,
--     },
--     vimgrep_arguments = {
--         "fd",
--         "--color=never",
--         "--no-heading",
--         "--with-filename",
--         "--line-number",
--         "--column",
--         "--smart-case",
--         "--no-ignore", -- добавлено это, остальное выше - по умолчанию
--     },
--     -- live_grep = {
--     --   additional_args = function(opts) return { "--hidden", "--no-ignore", "-i" } end,
--     -- },
--   },
--   --  defaults = {
--   -- vimgrep_arguments = {
--   --   "fd",
--   --   "--color=never",
--   --   "--no-heading",
--   --   "--with-filename",
--   --   "--line-number",
--   --   "--column",
--   --   "--ignore-case",
--   --   "--hidden",
--   --   "--recursive",
--   --   "--no-messages",
--   --   "--exclude-dir=*cache*",
--   --   "--exclude-dir=*.git",
--   --   --"--exclude=.*",
--   --   "--exclude=*.pp",
--   --   "--binary-files=without-match",
--   --   "--vimgrep",
--   -- },
--   -- find_command = {
--   --   "rg",
--   --   "--files",
--   --   "--color",
--   --   "never",
--   --   "--no-ignore",
--   --   "--hidden",
--   --   "--glob",
--   --   "!.git",
--   --   "etc",
--   -- },
--   --find_command = { "rg", "--files", "--color", "never", "--no-ignore", "--hidden" },
--   -- },
--   --:lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ winblend = 10 }))
-- }
-- require("telescope").load_extension "project"
-- require("telescope").load_extension "menu"

vim.cmd "set timeoutlen=0"

vim.cmd "set clipboard+=unnamedplus"
--vim.opt.clipboard:append { "unnamed", "unnamedplus" }

--vim.api.nvim_create_autocmd("BufNewFile", {
--  command = "Neorg templates load journal",
--  pattern = { "/home/ser/org/journal/*.norg" },
--})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "silent !/home/ser/.local/bin/hypr-switch-en",
})

vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "*",
  command = "silent !/home/ser/.local/bin/hypr-switch-en",
})
