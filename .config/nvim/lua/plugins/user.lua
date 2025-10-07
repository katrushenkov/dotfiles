return {
  {
    "samharju/yeet.nvim",
    dependencies = {
      "stevearc/dressing.nvim", -- optional, provides sane UX
    },
    version = "*",
    cmd = "Yeet",
    opts = {},
  },
  {
    "luukvbaal/nnn.nvim",
    config = function()
      require("nnn").setup {
        picker = {
          cmd = "nnn", -- command override (-p flag is implied)
          style = {
            width = 0.9, -- percentage relative to terminal size when < 1, absolute otherwise
            height = 0.8, -- ^
            xoffset = 0.5, -- ^
            yoffset = 0.5, -- ^
            border = "rounded", -- border decoration for example "rounded"(:h nvim_open_win)
          },
          session = "", -- or "global" / "local" / "shared"
          tabs = true, -- separate nnn instance per tab
          fullscreen = false, -- whether to fullscreen picker window when current tab is empty
        },
      }
    end,
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      ui = {
        enable = false,
      },
      attachments = {
        img_folder = "assets",
        img_text_func = require("obsidian.builtin").img_text_func,
        img_name_func = function() return string.format("Pasted image %s", os.date "%Y%m%d%H%M%S") end,
        confirm_img_paste = true,
      },
      workspaces = {
        -- {
        -- name = "personal",
        -- path = "~/vaults/personal",
        -- },
        {
          name = "work",
          path = "/home/ser/.local/src/datagrip",
        },
      },
    },
  },
  {
    "nvim-neorg/neorg",
    enabled = false,
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1000, -- We'd like this plugin to load first out of the rest
        config = true,
      },
      { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
      -- { "nvim-neorg/neorg-telescope" },
    },
    lazy = false,
    version = "*",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.itero"] = {},
          ["core.export"] = {},
          ["core.export.markdown"] = {
            config = {
              extensions = "all",
            },
          },
          ["core.concealer"] = { config = { icon_preset = "diamond" } },
          ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
          ["core.summary"] = {},
          ["core.journal"] = {
            config = {
              strategy = "flat", --"nested",
              workspace = "org",
              template_name = { "template.norg" }, -- for default ":Neorg journal template", file from journal_folder
              use_template = true,
              journal_folder = "journal",
            }, -- Enables support for the journal module
          },
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
              name = "[neorg]",
            },
          }, -- Enables support for completion plugins
          ["core.integrations.nvim-cmp"] = {},
          -- ["core.integrations.telescope"] = {},
          --["core.mode"] = {}, -- на версии 9.1.1 не работает
          ["core.integrations.treesitter"] = {},
          ["core.neorgcmd"] = {},
          -- ["core.neorgcmd.commands.module.list"] = {},
          -- ["core.ui.calendar"] = {},
          ["external.templates"] = {
            -- templates_dir = "/home/ser/.config/nvim/templates/norg",
            -- default_subcommand = "add", -- or "fload", "load"
            -- keywords = { -- Add your own keywords.
            --   EXAMPLE_KEYWORD = function ()
            --     return require("luasnip").insert_node(1, "default text blah blah")
            --   end,
            -- },
            -- snippets_overwrite = {},
          },
          ["core.keybinds"] = {
            -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
            config = {
              default_keybinds = true,
              --    neorg_leader = ";", --"<Leader><Leader>",
              --    --neorg_leader = "<Leader><Leader>",

              --    hook = function(keybinds)
              --      local local_leader = keybinds.leader
              --      keybinds.map_to_mode("norg", {
              --        n = {
              --          { local_leader .. "jj", ":Neorg journal today<CR>", opts = { desc = "Go to Today's Journal" } },
              --          {
              --            local_leader .. "jh",
              --            ":Neorg journal yesterday<CR>",
              --            opts = { desc = "Go to Yesterday's Journal" },
              --          },
              --          {
              --            local_leader .. "jl",
              --            ":Neorg journal tomorrow<CR>",
              --            opts = { desc = "Go to Tomorrow's Journal" },
              --          },
              --          { local_leader .. "jc", ":Neorg journal custom ", opts = { desc = "Go to Custom Journal" } },
              --        },
              --      })
              --      keybinds.map_to_mode("all", {
              --        n = {
              --          { local_leader .. "a", ":Neorg index<CR>", opts = { desc = "Go to index" } },
              --          { local_leader .. "b", ":Neorg index<CR>", opts = { desc = "Go to index" } },
              --        },
              --      })
              --    end,
            },
          },
          ["core.dirman"] = {
            config = {
              workspaces = {
                org = "~/.local/src/datagrip",
              },
              default_workspace = "org",
            },
          },
        },
      }
    end,
  },
  {
    "Kurren123/mssql.nvim",
    opts = {},
    config = function()
      require("mssql").setup {
        keymap_prefix = "<leader>m",
        max_rows = 50,
        max_column_width = 50,
        open_results_in = "current_window",
        --connections_file = nil,
      }
      require("mssql").set_keymaps ";m"
    end,
    dependencies = { "folke/which-key.nvim" },
  },
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
  { "max397574/better-escape.nvim", enabled = false },
  { "kevinhwang91/nvim-ufo", enabled = false },
  { "MunifTanjim/nui.nvim", enabled = false },
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "s1n7ax/nvim-window-picker", enabled = false },
  { "stevearc/resession.nvim", enabled = false },
  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts)
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if the previous character is xxx
            :with_pair(cond.not_before_regex("xxx", 3))
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    "folke/flash.nvim",
    config = function()
      require("flash").setup {
        modes = {
          search = {
            enabled = false, -- "/" labels mode
          },
          char = {
            keys = { "f", "F", "t", "T", "," },
            enabled = true,
            jump_labels = true,
          },
        },
      }
    end,
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
