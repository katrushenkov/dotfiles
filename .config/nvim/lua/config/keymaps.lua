-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--delete
--#vim.keymap.set('n', '<F13>', '<Esc>')
--#vim.keymap.set('i', '<F13>', '<Esc>')
--#vim.keymap.set('v', '<F13>', '<Esc>')

local opts = { noremap = true, silent = true }

vim.keymap.set({"n"},";J","<Cmd>edit $HOME/.local/src/datagrip/journal/journal.md<cr>G<ESC>",{ silent = true, desc = "Show journal" })


vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { noremap = true, desc = "Save window" })


vim.api.nvim_del_keymap("n", "<leader>qq")
vim.keymap.set({ "n" }, ";z", ":qa!<cr>", { silent = true, desc = "Quit without save" })
vim.keymap.set({ "n" }, "<leader>q", ":qa!<cr>", { silent = true, desc = "Quit without save" })

vim.keymap.set("n", "zn", "zR") -- open all (n = "open" в qwerty рядом)
vim.keymap.set("n", "zm", "zM") -- close all (original mnemo)
vim.keymap.set("n", ";z", "za")

vim.keymap.set({ "n" }, ";q", ":qa!<cr>", { silent = true, desc = "Quit without save" })
--vim.keymap.set({ "n" }, "<leader>q", "<Cmd>qa<CR>", { desc = "Quit all" })

vim.keymap.set("v", "<leader>yy", function()
  require("yeet").execute_selection("source venv/bin/activate", { clear_before_yeet = true })
end)

-- Tab navigation
vim.keymap.set({"n"}, "<s-tab>", "<cmd>tabnew %<cr>", opts)
vim.keymap.set({ "n" }, "<s-h>", "<cmd>tabp<cr>", opts)
vim.keymap.set({ "n" }, "<s-l>", "<cmd>tabn<cr>", opts)


vim.keymap.set("n", ";g", function()
  require("snacks").picker.files({
    cwd = vim.fn.expand("~/.config/nnn/bookmarks"),
    hidden = true, -- показывать скрытые файлы
    follow_symlinks = true,
    respect_gitignore = true,
  })
end, { desc = "Shortcuts picker" })

--Автоматически использовать системный буфер обмена для копирования и вставки
--vim.keymap.set("n", "y", '"+y') -- Копировать в системный буфер обмена
--vim.keymap.set("n", "p", '"+p') -- Вставить из системного буфера обмена

vim.keymap.set("n", "<leader>bk", "<Cmd>confirm bd<CR>", { desc = "kill buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { noremap = true })
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "<C-c>", ":Gitsigns blame_line<cr>", { silent = true })
vim.keymap.set("n", ";f", "<leader>f", { silent = true })
vim.keymap.set("n", ";a", ":edit ~/.local/src/datagrip/index.md<cr>", { silent = true })
vim.keymap.set("n", "J", ":bnext<cr>", { silent = true })
vim.keymap.set("n", ";h", ":chdir ~/.local/src/datagrip<cr>", { silent = true })
vim.keymap.set("n", ";n", ":NnnPicker<cr>", { silent = true, desc = "Toggle nnn" })
vim.keymap.set("n", ";N", ":NnnExplorer<cr>", { silent = true, desc = "Toggle nnn" })
vim.keymap.set("n", ";y", ":silent %y+<cr>", { silent = true, desc = "Yank the whole buffer" })
--  keymap.set("n", "<leader>y", "<cmd>%yank<cr>", { desc = "yank entire buffer" })

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
vim.keymap.set("n", "0", "^", { noremap = true })

-- Sudo write
vim.api.nvim_create_user_command("W", "silent! write !sudo tee % >/dev/null | edit!", {})

-- Replace ex mode with gq
vim.keymap.set("n", "Q", "gq", { noremap = true })

function JOURNAL_ADD()
  local date_year = tostring(os.date("%Y"))
  local date_month = tostring(os.date("%m"))
  local date_day = tostring(os.date("%d"))
  -- vim.notify("input ksm:" .. tostring(date_str))
  local file_path = vim.fn.expand("$HOME") .. "/.local/src/datagrip/journal/journal.md"
  local file = io.open(file_path, "r")
  date_found = false

  if file then
    for line in file:lines() do
      if line:match(date_year .. "%-" .. date_month .. "%-" .. date_day) then
        date_found = true
      end
    end
  else
    print("Не удалось открыть файл: " .. file_path)
  end
  file:close()

  local file = io.open(file_path, "a")
  if not date_found then
    file:write("\n" .. "[" .. date_year .. "-" .. date_month .. "-" .. date_day .. "]")
    file:write("\n -  ")
  else
    file:write(" -  ")
  end
  file:close()
  vim.cmd("edit " .. file_path)
  vim.cmd("normal G")
  vim.cmd("normal $")
  vim.cmd("startinsert")
  -- else
  -- vim.cmd "normal o" -- Если дата добавлена, курсор на строку с датой
  -- end
end

vim.keymap.set("n", ";j", "<cmd>lua JOURNAL_ADD()<CR>", opts)

--{ noremap = true, silent = false, desc = "test"})
