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
require "polish"

-- --------------------------------
-- init.lua
-- if vim.env.WAYLAND_DISPLAY and vim.fn.executable "wl-copy" and vim.fn.executable "wl-paste" then
--   vim.g.clipboard = {
--     name = "wl-copy",
--     copy = {
--       ["+"] = { "wl-copy", "--type", "text/plain" },
--       ["*"] = { "wl-copy", "--primary", "--type", "text/plain" },
--     },
--     paste = {
--       ["+"] = { "wl-paste", "--no-newline" },
--       ["*"] = { "wl-paste", "--no-newline", "--primary" },
--     },
--   }
-- end
-- --------------------------------

local project_actions = require "telescope._extensions.project.actions"
require("telescope").setup {
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "ignore_case", -- or "ignore_case" or "respect_case"
    },
    project = {
      base_dirs = {
        { path = "~/.local/src", max_depth = 2 },
        --{ "~/.local/src/datagrip" },
        --{ "~/.local/src" },
      },
      --display_type = false,не влияет
      --display_type = true,
      theme = "dropdown",
      order_by = "asc",
      search_by = "title",
      hidden_files = true, -- default: false
      on_project_selected = function(prompt_bufnr)
        --require("telescope._extensions.project.actions").change_working_directory(prompt_bufnr)
        project_actions.change_working_directory(prompt_bufnr)
      end,
      --on_project_selected = function(prompt_bufnr) _actions.find_project_files(prompt_bufnr, hidden_files) end,
    },
  },
  pickers = {
    find_files = {
      theme = "ivy", --dropdown
      hidden_files = true,
      hidden = true,
      no_ignore = true,
      no_ignore_parent = true,
    },
    live_grep = {
      additional_args = function(opts)
           return {"--hidden","--no-ignore"}
        end
    },
  },
  --  defaults = {
  -- vimgrep_arguments = {
  --   "fd",
  --   "--color=never",
  --   "--no-heading",
  --   "--with-filename",
  --   "--line-number",
  --   "--column",
  --   "--ignore-case",
  --   "--hidden",
  --   "--recursive",
  --   "--no-messages",
  --   "--exclude-dir=*cache*",
  --   "--exclude-dir=*.git",
  --   --"--exclude=.*",
  --   "--exclude=*.pp",
  --   "--binary-files=without-match",
  --   "--vimgrep",
  -- },
  -- find_command = {
  --   "rg",
  --   "--files",
  --   "--color",
  --   "never",
  --   "--no-ignore",
  --   "--hidden",
  --   "--glob",
  --   "!.git",
  --   "etc",
  -- },
  --find_command = { "rg", "--files", "--color", "never", "--no-ignore", "--hidden" },
  -- },
  --:lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ winblend = 10 }))
}
--require("telescope").load_extension "fzf"

require("telescope").load_extension "project"
vim.api.nvim_set_keymap(
  "n",
  "<C-p>",
  ":lua require'telescope'.extensions.project.project{}<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n","<leader>fp",":lua require'telescope'.extensions.project.project{}<CR>",{ noremap = true, silent = true, desc = "Show projects" })

vim.keymap.set("v", "<leader>yy", function()
    require("yeet").execute_selection(
        "source venv/bin/activate",
        { clear_before_yeet = true }
    )
end)

vim.cmd "set timeoutlen=0"

vim.cmd "set clipboard+=unnamedplus"
--vim.opt.clipboard:append { "unnamed", "unnamedplus" }

--Автоматически использовать системный буфер обмена для копирования и вставки
--vim.keymap.set("n", "y", '"+y') -- Копировать в системный буфер обмена
--vim.keymap.set("n", "p", '"+p') -- Вставить из системного буфера обмена

vim.api.nvim_set_keymap( "n", ";J", ":edit /home/ser/.local/src/datagrip/journal/journal.md<cr>G<ESC>",  { silent = true, desc = "Show journal" })
vim.api.nvim_set_keymap(
  "n",
  ";j",
  --":Neorg journal today<cr>:w<cr>G$a<cr><ESC>:Neorg templates add journal<cr>",
  ":edit /home/ser/.local/src/datagrip/journal/journal.md<cr>G<ESC>:put =strftime('[%F]')<CR>$a ",
  --":Neorg journal today<cr>:Neorg templates add journal<cr>",
  { silent = true, desc = "Add to journal" }
) -- set via neorg_leader
--vim.keymap.set(
--  { "n" },
--  "<leader>E",
--  ":Neotree source=filesystem reveal_force_cwd position=float<cr>",
--  { desc = "Toggle neotree" }
--)
--vim.keymap.set(
--  { "n" },
--  "<leader>e",
--  ":Neotree source=filesystem reveal_force_cwd position=float<cr>",
--  { desc = "Toggle neotree" }
--)

vim.keymap.set("n", "<leader>sh", ":nohl<CR>")

vim.keymap.set({ "n" }, ";z", ":qa!<cr>", { desc = "Quit without save" })

vim.keymap.set(
  { "n" },
  ";e",
  ":Neotree source=filesystem reveal_force_cwd position=float<cr>",
  { desc = "Toggle neotree" }
)
vim.keymap.set(
  { "n" },
  ";E",
  ":Neotree source=filesystem reveal_force_cwd position=float<cr>",
  { desc = "Toggle neotree" }
)
vim.keymap.set({ "n" }, "<leader>bk", "<Cmd>bd<CR>", { desc = "kill buffer" })
vim.api.nvim_set_keymap("n", "<S-Tab>", ":bprev<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Tab>", ":bnext<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", ":Gitsigns blame_line<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "f", ":HopWord<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":HopLineAC<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", ":HopLineBC<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":ZenMode<cr>", { silent = true })
vim.api.nvim_set_keymap("n", ";f", "<leader>f", { silent = true })
vim.api.nvim_set_keymap("n", ";a", ":edit ~/.local/src/datagrip/index.md<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "J", ":bnext<cr>", { silent = true })
vim.api.nvim_set_keymap("n", "<leader>ss", ":Telescope current_buffer_fuzzy_find<cr>", { silent = true })
vim.keymap.set("n",";w",":Telescope live_grep<cr>",{ desc = "Find word in all files" })
vim.keymap.set("n","<leader>fw",":Telescope live_grep<cr>",{ desc = "Find word in all files" })

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
vim.api.nvim_set_keymap(
  "n",
  ";g",
  ":lua require'telescope'.extensions.project.project{}<cr>",
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap("n", ";h", ":chdir ~/.local/src/datagrip<cr>", { silent = true })
vim.api.nvim_set_keymap("n", ";x", ":Telescope find_files<cr>", { silent = true })
vim.api.nvim_set_keymap("n", ";f", ":Telescope current_buffer_fuzzy_find<cr>", { silent = true })
vim.api.nvim_set_keymap("n", ";n", ":NnnPicker<cr>", { silent = true, desc = "Toggle nnn" })
vim.api.nvim_set_keymap("n", ";N", ":NnnExplorer<cr>", { silent = true, desc = "Toggle nnn" })
vim.api.nvim_set_keymap("n", ";y", ":silent %y+<cr>", { silent = true, desc = "Yank the whole buffer" })
-- vim.api.nvim_set_keymap(
--   "i",
--   "<ESC>",
--   ":!hyprctl switchxkblayout e-signal-usb-gaming-mouse-keyboard 0",
--   { silent = true }
-- )

--vim.keymap.set("n", "<lhs>", "<Plug>(neorg.telescope.search_headings)")
--vim.keymap.set('n', '<leader>E', '<Cmd>Neotree<CR>', {position=current})
--vim.keymap.set({ "n" }, "<leader>x", ":NnnExplorer<cr>", { desc = "Toggle nnn" })
--vim.keymap.set({"n"}, '<C-b>', '<Cmd>Neotree toggle<CR>')
--vim.keymap.set({ "i" }, "<C-b>", "<ESC><Cmd>Neotree toggle<CR>")
--vim.keymap.set("n","<leader>z", ":lua require('zen-mode').toggle({})<cr>", {desc = "Toggle [z]enmode"})
--vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Copy from system clipboard' })
--vim.cmd("nnoremap Q <nop>") -- don't fuck with Ex mode
--vim.cmd("nnoremap j gj") -- don't fuck with line-wrapping
--vim.cmd("nnoremap k gk") -- don't fuck with line-wrapping
--alternative in lua
--Disable the Q command
--vim.api.nvim_set_keymap("n", "Q", "<nop>", { noremap = true })
--Move by display lines, not actual lines
--vim.api.nvim_set_keymap("n", "j", "gj", {})
--vim.api.nvim_set_keymap("n", "k", "gk", {})
--Move to the first non-blank character of the line
--vim.api.nvim_set_keymap("n", "0", "^", { noremap = true })

--vim.api.nvim_create_autocmd("BufNewFile", {
--  command = "Neorg templates load journal",
--  pattern = { "/home/ser/org/journal/*.norg" },
--})

-- почему-то не всегда отрабатывает
--vim.api.nvim_create_autocmd("InsertLeave", {
--  desc = "update diff",
--  group = init_group,
--  pattern = "*",
--  -- command = "if &l:diff | diffupdate | endif",
--  --command = "!hyprctl switchxkblayout e-signal-usb-gaming-mouse-keyboard next",
--  callback = function() vim.cmd "silent !hyprctl switchxkblayout e-signal-usb-gaming-mouse-keyboard 0" end,
--})

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  group = init_group,
  --command = 'silent !/usr/bin/hyprctl switchxkblayout "2.4g-mouse" 0 > /dev/null',
  command = 'silent !/usr/bin/hyprctl switchxkblayout "logitech-usb-keyboard" 0 > /dev/null',

  --command = "silent !/home/ser/.local/bin/toen",
})

vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = "*",
  group = init_group,
  --command = 'silent !/usr/bin/hyprctl switchxkblayout "2.4g-mouse" 0 > /dev/null',
  command = 'silent !/usr/bin/hyprctl switchxkblayout "logitech-usb-keyboard" 0 > /dev/null',
})
