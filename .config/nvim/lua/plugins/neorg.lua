return {
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
}
