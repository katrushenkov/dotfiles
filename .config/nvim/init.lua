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
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"

require("telescope").setup {
  extensions = {
    project = {
      base_dirs = {
        --{ "~/.local/src/datagrip/org" },
        --{ "~/.local/src" },
        --        { "~/dev/src3", max_depth = 4 },
        { path = "~/.local/src" },
        --        { path = "~/dev/src5", max_depth = 2 },
      },
      hidden_files = true, -- default: false
      display_type = true,
      theme = "dropdown",
      --   on_project_selected = function(prompt_bufnr)
    },
  },
  -- Добавлял на ура, не факт что это работает
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--ignore-case",
      "--hidden",
    },
    find_command = { "rg", "--files", "--color", "never", "--no-ignore", "--hidden", "--glob", "!.git", "etc", "etc" },
  },
}
require("telescope").load_extension "project"
vim.api.nvim_set_keymap(
  "n",
  "<C-p>",
  ":lua require'telescope'.extensions.project.project{}<CR>",
  { noremap = true, silent = true }
)

vim.cmd "set timeoutlen=0"

vim.opt.clipboard:append { "unnamed", "unnamedplus" }

vim.api.nvim_set_keymap(
  "n",
  ";j",
  ":Neorg journal today<cr>:w<cr>G$a<cr><ESC>:Neorg templates add journal<cr>",
  --":Neorg journal today<cr>:Neorg templates add journal<cr>",
  --":Neorg journal today<cr>",
  { silent = true, desc = "Journal today" }
) -- set via neorg_leader
vim.keymap.set({ "n" }, "<leader>E", ":Neotree position=float toggle<cr>", { desc = "Toggle neotree" })
vim.keymap.set({ "n" }, "<leader>bk", "<Cmd>bd<CR>", { desc = "kill buffer" })
vim.api.nvim_set_keymap("n", "<S-Tab>", ":bprev<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Tab>", ":bnext<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "f", ":HopWord<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":HopLineAC<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":HopLineBC<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":ZenMode<cr>", { silent = true })
vim.api.nvim_set_keymap("n", ";f", "<leader>f", { silent = true })
vim.api.nvim_set_keymap("n", ";a", ":Neorg index<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "J", ":bnext<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>ss", ":Telescope current_buffer_fuzzy_find<cr>", { silent = true })
vim.keymap.set(
  "n",
  "<leader>fG",
  "<Plug>(neorg.telescope.search_headings)",
  { silent = true, desc = "Telescope neorg headings" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fg",
  ":Telescope neorg search_headings<cr>",
  { silent = true, desc = "Telescope neorg headings" }
)
vim.api.nvim_set_keymap("n", ";g", ":Telescope project<cr>", { silent = true })
vim.api.nvim_set_keymap("n", ";x", ":Telescope find_files<cr>", { silent = true })
vim.api.nvim_set_keymap("n", ";n", ":NnnPicker<cr>", { silent = true, desc = "Toggle nnnn" })
--vim.keymap.set("n", "<lhs>", "<Plug>(neorg.telescope.search_headings)")
--vim.keymap.set('n', '<leader>E', '<Cmd>Neotree<CR>', {position=current})
--vim.keymap.set({ "n" }, "<leader>x", ":NnnExplorer<cr>", { desc = "Toggle nnn" })
--vim.keymap.set({"n"}, '<C-b>', '<Cmd>Neotree toggle<CR>')
--vim.keymap.set({ "i" }, "<C-b>", "<ESC><Cmd>Neotree toggle<CR>")
--vim.keymap.set("n","<leader>z", ":lua require('zen-mode').toggle({})<cr>", {desc = "Toggle [z]enmode"})
--vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy from system clipboard' })
-- vim.cmd("nnoremap Q <nop>") -- don't fuck with Ex mode
-- vim.cmd("nnoremap j gj") -- don't fuck with line-wrapping
-- vim.cmd("nnoremap k gk") -- don't fuck with line-wrapping
-- alternative in lua
-- Disable the Q command
-- vim.api.nvim_set_keymap("n", "Q", "<nop>", { noremap = true })
-- Move by display lines, not actual lines
-- vim.api.nvim_set_keymap("n", "j", "gj", {})
-- vim.api.nvim_set_keymap("n", "k", "gk", {})
-- Move to the first non-blank character of the line
-- vim.api.nvim_set_keymap("n", "0", "^", { noremap = true })

-- Как-то для неорга можно использовать
--vim.api.nvim_create_autocmd("BufNewFile", {
--  command = "Neorg templates load journal",
--  pattern = { "/home/ser/org/journal/*.norg" },
--})

--vim.cmd "set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

--require "lazy_setup"
require "polish"
