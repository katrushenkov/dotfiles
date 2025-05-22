
vim.keymap.set("n", "<leader>sh", ":nohl<CR>")

--Автоматически использовать системный буфер обмена для копирования и вставки
--vim.keymap.set("n", "y", '"+y') -- Копировать в системный буфер обмена
--vim.keymap.set("n", "p", '"+p') -- Вставить из системного буфера обмена

vim.keymap.set("n",";J",":edit /home/ser/.local/src/datagrip/journal/journal.md<cr>G<ESC>",{ silent = true, desc = "Show journal" })

vim.keymap.set(
  "n",
  ";j",
  --":Neorg journal today<cr>:w<cr>G$a<cr><ESC>:Neorg templates add journal<cr>",
  ":edit /home/ser/.local/src/datagrip/journal/journal.md<cr>G<ESC>:put =strftime('[%F]')<CR>$a ",
  --":Neorg journal today<cr>:Neorg templates add journal<cr>",
  { silent = true, desc = "Add to journal" }
) -- set via neorg_leader
--vim.keymap.set("n","<leader>E",":Neotree source=filesystem reveal_force_cwd position=float<cr>",{ desc = "Toggle neotree" })
--vim.keymap.set("n","<leader>e",":Neotree source=filesystem reveal_force_cwd position=float<cr>",{ desc = "Toggle neotree" })

vim.keymap.set({ "n" }, ";z", ":qa!<cr>", { desc = "Quit without save" })

vim.keymap.set("n",";e",":Neotree source=filesystem reveal_force_cwd position=float<cr>",{ desc = "Toggle neotree" })
vim.keymap.set(
  { "n" },
  ";E",
  ":Neotree source=filesystem reveal_force_cwd position=float<cr>",
  { desc = "Toggle neotree" }
)
vim.keymap.set({ "n" }, "<leader>bk", "<Cmd>bd<CR>", { desc = "kill buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { noremap = true })
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "S", ":HopWord<cr>", { silent = true })
vim.keymap.set("n", "<C-c>", ":Gitsigns blame_line<cr>", { silent = true })
vim.keymap.set("n", "f", ":HopWord<cr>", { silent = true })
vim.keymap.set("n", "<C-j>", ":HopLineAC<cr>", { silent = true })
vim.keymap.set("n", "<C-k>", ":HopLineBC<cr>", { silent = true })
vim.keymap.set("n", "<C-h>", ":ZenMode<cr>", { silent = true })
vim.keymap.set("n", ";f", "<leader>f", { silent = true })
vim.keymap.set("n", ";a", ":edit ~/.local/src/datagrip/index.md<cr>", { silent = true })
vim.keymap.set("n", "J", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<leader>ss", ":Telescope current_buffer_fuzzy_find<cr>", { silent = true })
vim.keymap.set("n", ";w", ":Telescope live_grep<cr>", { desc = "Find word in all files" })
-- vim.keymap.set("n", "<leader>fw", ":Telescope live_grep<cr>", { desc = "Find word in all files" })

vim.keymap.set("n","<leader>fG","<Plug>(neorg.telescope.search_headings)",{ silent = true, desc = "Telescope neorg headings" })

vim.keymap.set("n","<leader>fg",":Telescope neorg search_headings<cr>",{ silent = true, desc = "Telescope neorg headings" })
vim.keymap.set("n",";g",":lua require'telescope'.extensions.project.project{}<cr>",{ silent = true, noremap = true })
vim.keymap.set("n", ";h", ":chdir ~/.local/src/datagrip<cr>", { silent = true })
vim.keymap.set("n", ";x", ":Telescope find_files<cr>", { silent = true })
vim.keymap.set("n", ";f", ":Telescope current_buffer_fuzzy_find<cr>", { silent = true })
vim.keymap.set("n", ";n", ":NnnPicker<cr>", { silent = true, desc = "Toggle nnn" })
vim.keymap.set("n", ";N", ":NnnExplorer<cr>", { silent = true, desc = "Toggle nnn" })
vim.keymap.set("n", ";y", ":silent %y+<cr>", { silent = true, desc = "Yank the whole buffer" })
-- vim.keymap.set(
--   "i",
--   "<ESC>",
--   ":!hyprctl switchxkblayout e-signal-usb-gaming-mouse-keyboard 0",
--   { silent = true }
-- )

vim.api.nvim_set_keymap("n","<C-p>",":lua require'telescope'.extensions.project.project{}<CR>",{ noremap = true, silent = true })
vim.api.nvim_set_keymap("n","<leader>fp",":lua require'telescope'.extensions.project.project{}<CR>",{ noremap = true, silent = true, desc = "Show projects"})

vim.keymap.set("v","<leader>yy",function() require("yeet").execute_selection("source venv/bin/activate", { clear_before_yeet = true }) end)
