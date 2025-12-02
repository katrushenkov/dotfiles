return {
  --  {
  --    "samharju/yeet.nvim",
  --    dependencies = {
  --      "stevearc/dressing.nvim", -- optional, provides sane UX
  --    },
  --    version = "*",
  --    cmd = "Yeet",
  --    opts = {},
  --  },
  --  {
  --    "luukvbaal/nnn.nvim",
  --    config = function()
  --      require("nnn").setup {
  --        picker = {
  --          cmd = "nnn",          -- command override (-p flag is implied)
  --          style = {
  --            width = 0.9,        -- percentage relative to terminal size when < 1, absolute otherwise
  --            height = 0.8,       -- ^
  --            xoffset = 0.5,      -- ^
  --            yoffset = 0.5,      -- ^
  --            border = "rounded", -- border decoration for example "rounded"(:h nvim_open_win)
  --          },
  --          session = "",         -- or "global" / "local" / "shared"
  --          tabs = true,          -- separate nnn instance per tab
  --          fullscreen = false,   -- whether to fullscreen picker window when current tab is empty
  --        },
  --      }
  --    end,
  --  },
  {
    "obsidian-nvim/obsidian.nvim",
    enabled = false,
    version = "*", -- recommended, use latest release instead of latest commit
    -- enabled = false,
    -- lazy = false,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    opts = {
      legacy_commands = false,
      -- disable_frontmatter = true,
      -- note_frontmatter_func = require("obsidian.builtin").frontmatter,
      ui = {
        enable = false,
      },
      keys = {
        { '<leader>ob', '<cmd>ObsidianBacklinks<cr>', desc = '[O]bisidan [B]acklinks' },
        { '<leader>od', '<cmd>ObsidianDailies<cr>',   '[O]sidian [D]ailies' },
        {
          '<leader>oe',
          function()
            vim.ui.input({ prompt = 'Enter Note Title: ' }, function(title)
              if title == nil or title == '' then
                return
              end

              vim.cmd('ObsidianExtractNote ' .. title)
            end)
          end,
          desc = '[O]sidian [E]xtract Note',
          mode = { 'v' },
        },
        { '<leader>ol', '<cmd>ObsidianLinks<cr>',       '[O]sidian [L]inks' },
        { '<leader>on', '<cmd>ObsidianNew<cr>',         '[O]sidian [N]ew' },
        { '<leader>oo', '<cmd>ObsidianOpen<cr>',        desc = '[O]pen in [O]bsidian' },
        { '<leader>oq', '<cmd>ObsidianQuickSwitch<cr>', '[O]sidian [Q]uick Swith' },
        { '<leader>or', '<cmd>ObsidianRename<cr>',      '[O]sidian [R]ename' },
        { '<leader>os', '<cmd>ObsidianSearch<cr>',      '[O]sidian [S]earch' },
        { '<leader>ot', '<cmd>ObsidianTags<cr>',        '[O]sidian [T]ags' },
      },
      -- attachments = {
      --   img_folder = "assets",
      --   img_text_func = require("obsidian.builtin").img_text_func,
      --   img_name_func = function() return string.format("Pasted image %s", os.date "%Y%m%d%H%M%S") end,
      --   confirm_img_paste = true,
      -- },
      workspaces = {
        {
          name = "work",
          path = "/home/ser/.local/src/datagrip",
        },
      },
    },
  },
  -- {
  --   "Kurren123/mssql.nvim",
  --   opts = {},
  --   config = function()
  --     require("mssql").setup {
  --       keymap_prefix = "<leader>m",
  --       max_rows = 50,
  --       max_column_width = 50,
  --       open_results_in = "current_window",
  --       --connections_file = nil,
  --     }
  --     require("mssql").set_keymaps ";m"
  --   end,
  --   dependencies = { "folke/which-key.nvim" },
  -- },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false,
        preset = {
          header = table.concat({}, "\n"),
        },
      },
    },
    --  keys = {
    --  	{
    --  		"<leader>e",
    --  		function()
    --  			local snacks = Snacks.picker.current
    --  			if snacks then
    --  				snacks.input.win:focus()
    --  			else
    --  				Snacks.explorer({ focus = "input" })
    --  			end
    --  		end,
    --  		desc = "Find files",
    --  	},
    -- },
  },
  -- You can disable default plugins as follows:
  --  { "max397574/better-escape.nvim", enabled = false },
  --  { "kevinhwang91/nvim-ufo",        enabled = false },
  --  { "MunifTanjim/nui.nvim",         enabled = false },
  --  { "nvim-neo-tree/neo-tree.nvim",  enabled = false },
  --  { "s1n7ax/nvim-window-picker",    enabled = false },
  --  { "stevearc/resession.nvim",      enabled = false },
  --  {
  --    "windwp/nvim-autopairs",
  --    enabled = false,
  --    config = function(plugin, opts)
  --      require "astronvim.plugins.configs.nvim-autopairs" (plugin, opts)
  --      -- add more custom autopairs configuration such as custom rules
  --      local npairs = require "nvim-autopairs"
  --      local Rule = require "nvim-autopairs.rule"
  --      local cond = require "nvim-autopairs.conds"
  --      npairs.add_rules(
  --        {
  --          Rule("$", "$", { "tex", "latex" })
  --          -- don't add a pair if the next character is %
  --              :with_pair(cond.not_after_regex "%%")
  --          -- don't add a pair if the previous character is xxx
  --              :with_pair(cond.not_before_regex("xxx", 3))
  --          -- don't move right when repeat character
  --              :with_move(cond.none())
  --          -- don't delete if the next character is xx
  --              :with_del(cond.not_after_regex "xx")
  --          -- disable adding a newline when you press <cr>
  --              :with_cr(cond.none()),
  --        },
  --        -- disable for .vim files, but it work for another filetypes
  --        Rule("a", "a", "-vim")
  --      )
  --    end,
  --  },
  { "folke/persistence.nvim", enabled = false },
  {
    "folke/flash.nvim",
    config = function()
      require("flash").setup {
        modes = {
          search = {
            enabled = false, -- "/" labels mode
          },
          char = {
            keys = { "F", "t", "T", "," }, -- "f" replaced with jump()
            enabled = true,
            jump_labels = true,
          },
        },
      }
    end,
    keys = {
      { "f",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      -- { "s", mode = { "n", "x", "o" },
      --   function() require("flash").jump { search = { mode = function(str) return "\\<" .. str end } } end, desc = "Flash",}, -- match beginnings of the words only
      -- { "s", mode = { "n", "x", "o" },
      --   function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end, desc = "Flash"}, -- with the word under the cursor
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = { "o" },           function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
}
