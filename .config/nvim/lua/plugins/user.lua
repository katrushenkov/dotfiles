-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder

return {
  {
    "nvim-telescope/telescope-project.nvim",
    config = function() require("telescope").load_extension "project" end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
  {
    --https://github.com/luukvbaal/nnn.nvim
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
            border = "single", -- border decoration for example "rounded"(:h nvim_open_win)
          },
          session = "", -- or "global" / "local" / "shared"
          tabs = true, -- separate nnn instance per tab
          fullscreen = false, -- whether to fullscreen picker window when current tab is empty
        },
      }
    end,
  },
  { "folke/zen-mode.nvim", cmd = "ZenMode" },
  { "ivanesmantovich/xkbswitch.nvim", config = function() require("xkbswitch").setup() end },
  {
    "nvim-neorg/neorg",
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1000, -- We'd like this plugin to load first out of the rest
        config = true,
      },
      { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
      { "nvim-neorg/neorg-telescope" },
    },
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
          ["core.integrations.telescope"] = {},
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
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.filesystem.filtered_items = {
        hide_gitignored = false,
        visible = true,
        hide_dotfiles = false,
      }
      opts.buffers = {
        follow_current_file = {
          enabled = true,
        },
      }
      opts.filesystem = {
        follow_current_file = {
          enabled = true,
        },
      }
      -- opts.filesystem = {
      --
      --   bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
      --   cwd_target = {
      --     sidebar = "tab", -- sidebar is when position = left or right
      --     current = "window", -- current is when position = current
      --     --    float = "tab"
      --   },
      --    window = {
      --       mappings = {
      --       -- disable fuzzy finder -- fix search by /
      --       ["/"] = "noop"
      --       }
      --     }
      --}
      return opts
    end,
  },
  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },
}

-- ---@type LazySpec
-- return {
--
--   -- == Examples of Adding Plugins ==
--   "andweeb/presence.nvim",
--   {
--     "ray-x/lsp_signature.nvim",
--     event = "BufRead",
--     config = function() require("lsp_signature").setup() end,
--   },
--
--   -- == Examples of Overriding Plugins ==
--   -- customize alpha options
--   {
--     "goolord/alpha-nvim",
--     opts = function(_, opts)
--       -- customize the dashboard header
--       opts.section.header.val = {
--         " █████  ███████ ████████ ██████   ██████",
--         "██   ██ ██         ██    ██   ██ ██    ██",
--         "███████ ███████    ██    ██████  ██    ██",
--         "██   ██      ██    ██    ██   ██ ██    ██",
--         "██   ██ ███████    ██    ██   ██  ██████",
--         " ",
--         "    ███    ██ ██    ██ ██ ███    ███",
--         "    ████   ██ ██    ██ ██ ████  ████",
--         "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
--         "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
--         "    ██   ████   ████   ██ ██      ██",
--       }
--       return opts
--     end,
--   },
--
--
--   -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
--   {
--     "L3MON4D3/LuaSnip",
--     config = function(plugin, opts)
--       require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
--       -- add more custom luasnip configuration such as filetype extend or custom snippets
--       local luasnip = require "luasnip"
--       luasnip.filetype_extend("javascript", { "javascriptreact" })
--     end,
--   },
--
--   {
--     "windwp/nvim-autopairs",
--     config = function(plugin, opts)
--       require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
--       -- add more custom autopairs configuration such as custom rules
--       local npairs = require "nvim-autopairs"
--       local Rule = require "nvim-autopairs.rule"
--       local cond = require "nvim-autopairs.conds"
--       npairs.add_rules(
--         {
--           Rule("$", "$", { "tex", "latex" })
--             -- don't add a pair if the next character is %
--             :with_pair(cond.not_after_regex "%%")
--             -- don't add a pair if  the previous character is xxx
--             :with_pair(
--               cond.not_before_regex("xxx", 3)
--             )
--             -- don't move right when repeat character
--             :with_move(cond.none())
--             -- don't delete if the next character is xx
--             :with_del(cond.not_after_regex "xx")
--             -- disable adding a newline when you press <cr>
--             :with_cr(cond.none()),
--         },
--         -- disable for .vim files, but it work for another filetypes
--         Rule("a", "a", "-vim")
--       )
--     end,
--   },
-- }
