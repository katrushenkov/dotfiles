
vim.keymap.set("n", "<leader>sh", ":nohl<CR>")

--Автоматически использовать системный буфер обмена для копирования и вставки
--vim.keymap.set("n", "y", '"+y') -- Копировать в системный буфер обмена
--vim.keymap.set("n", "p", '"+p') -- Вставить из системного буфера обмена

vim.keymap.set("n",";J",":edit /home/ser/.local/src/datagrip/journal/journal.md<cr>G<ESC>",{ silent = true, desc = "Show journal" })

-- vim.keymap.set(
--   "n",
--   ";j",
--   --":Neorg journal today<cr>:w<cr>G$a<cr><ESC>:Neorg templates add journal<cr>",
--   ":edit /home/ser/.local/src/datagrip/journal/journal.md<cr>G<ESC>:put =strftime('[%F]')<CR>$a ",
--   --":Neorg journal today<cr>:Neorg templates add journal<cr>",
--   { silent = true, desc = "Add to journal" }
-- ) -- set via neorg_leader
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

-- Sudo write
vim.api.nvim_create_user_command("W", "silent! write !sudo tee % >/dev/null | edit!", {})

-- Replace ex mode with gq
vim.keymap.set("n", "Q", "gq", { noremap = true })

function JOURNAL_ADD()
    local date_str = os.date('[%Y-%m-%d]')
    local file_path = '/home/ser/.local/src/datagrip/journal/journal.md'
    -- Читаем содержимое файла
    local lines = {}
    local file = io.open(file_path, 'r')
    if file then
        for line in file:lines() do
            table.insert(lines, line)
        end
        file:close()
    end
    -- Проверяем, есть ли строка с текущей датой
    local date_found = false
    for line in ipairs(lines) do
        if line:match(os.date("%Y-%m-%d")) then
            date_found = true
            break
        end
    end
    -- Открываем файл для записи
    file = io.open(file_path, 'w')
    if not file then
        vim.notify('Не удалось открыть файл для записи: ' .. file_path, vim.log.levels.ERROR)
        return
    end
    -- Записываем все существующие строки
    for _, line in ipairs(lines) do
        file:write(line .. '\n')
    end
    -- Если дата не найдена, добавляем её в конец файла
    if not date_found then
        file:write('\n' .. date_str .. '\n')
    else
        -- Если дата найдена, добавляем новый пункт
        file:write('\n- ')
    end
    file:close()
    -- Открываем файл в Neovim
    vim.cmd('edit ' .. file_path)
    -- Перемещаем курсор в нужное место
    vim.cmd('normal G')  -- Переход в конец файла
    if date_found then
        vim.cmd('normal $')  -- Если дата была, курсор в конец последней строки
    else
        vim.cmd('normal k$')  -- Если дата добавлена, курсор на строку с датой
    end
end

vim.keymap.set("n", ";j", "<cmd>lua JOURNAL_ADD()<CR>", opts)

  --{ noremap = true, silent = false, desc = "test"})
