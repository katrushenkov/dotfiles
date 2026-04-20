-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

vim.keymap.set(
  "n",
  "<leader>k",
  '<cmd>lua require("kubectl").toggle({ tab = true })<cr>',
  opts
)

vim.keymap.set({"n"},";J","<Cmd>edit $HOME/.local/src/datagrip/journal/journal.md<cr>G<ESC>",{ silent = true, desc = "Show journal" })

vim.api.nvim_del_keymap("n", "<leader>qq")
vim.keymap.set({ "n" }, ";z", "<cmd>qa!<cr>", { silent = true, desc = "Quit without save" })
vim.keymap.set({ "n" }, "<leader>q", "<cmd>qa<cr>", { silent = true, desc = "Quit without save" })

vim.keymap.set("n", "zn", "zR") -- open all
vim.keymap.set("n", "zm", "zM") -- close all
vim.keymap.set("n", "zo", "zR") -- open all
vim.keymap.set("n", "zc", "zM") -- close all
vim.keymap.set("n", ";z", "za")

vim.keymap.set({ "n" }, ";q", ":qa!<cr>", { silent = true, desc = "Quit without save" })
--vim.keymap.set({ "n" }, "<leader>q", "<Cmd>qa<CR>", { desc = "Quit all" })

-- Tab navigation
vim.keymap.set({"n"}, "<s-tab>", "<cmd>tabnew %<cr>", opts)
vim.keymap.set({"n"}, "<s-h>", "<cmd>tabp<cr>", opts)
vim.keymap.set({"n"}, "<s-l>", "<cmd>tabn<cr>", opts)

vim.keymap.set("n", ";g", function()
  require("snacks").picker.files({
    cwd = vim.fn.expand("~/.config/nnn/bookmarks"),
    hidden = true,
    follow_symlinks = true,
    respect_gitignore = true,
  })
end, { desc = "Shortcuts picker" })

vim.keymap.set("n", "<leader>bk", "<Cmd>confirm bd<CR>", { desc = "kill buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", opts)
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<C-c>", ":Gitsigns blame_line<cr>", opts)
vim.keymap.set("n", ";a", ":edit ~/.local/src/datagrip/index.md<cr>", opts)
vim.keymap.set("n", "J", ":bnext<cr>", opts)
vim.keymap.set("n", ";h", ":chdir ~/.local/src/datagrip<cr>", opts)
vim.keymap.set("n", ";y", ":silent %y+<cr>", { silent = true, desc = "Yank the whole buffer" })


vim.keymap.set("n",';t', '<cmd>Obsidian tags<cr>', { silent = true, desc = 'Obsidian tags'})

-- Move to the first non-blank character of the line
vim.keymap.set("n", "0", "^", opts)

-- Sudo write
vim.api.nvim_create_user_command("W", "silent! write !sudo tee % >/dev/null | edit!", {})

-- Replace ex mode with gq
vim.keymap.set("n", "Q", "gq", opts)

function journal_add()
  local date_year = tostring(os.date("%Y"))
  local date_month = tostring(os.date("%m"))
  local date_day = tostring(os.date("%d"))
  -- vim.notify("input ksm:" .. tostring(date_str))
  local file_path = vim.fn.expand("$HOME") .. "/.local/src/datagrip/journal/journal.md"
  local file = io.open(file_path, "r")
  local date_found = false

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
  -- vim.cmd "normal o"
  -- end
end

vim.keymap.set("n", ";j", "<cmd>lua journal_add()<CR>", vim.tbl_extend("force", opts, { desc = "Add journal entry" }))

vim.keymap.del("n", "<leader>wd")
vim.keymap.del("n", "<leader>wm")
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { noremap = true, desc = "Save buffer" })
