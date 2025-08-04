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
  
      -- see below for full list of options 👇
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
            require("flash").setup({
                modes = {
                    search = {
                        enabled = true,
                    },
                    char = {
                        keys = { "f", "F", "t", "T", "," },
                        enabled = true,
                        jump_labels = true,
                    },
                },
            })
        end,
  -- --   keys = {
  -- --       { ";", nil },
  -- --     },
  -- --   modes = {
  -- --      char = {
  -- --        -- keys = { "f", "F", "t", "T", "," },
  -- --         keys = {
  -- --             { ";", nil },
  -- --           }
  -- --      }
  -- --   },
  },
  {
    "folke/snacks.nvim",
    opts = {
      matcher = {
        fuzzy = true,
        ignorecase = true,
        smartcase = true,
        sort_empty = false,
        file_pos = true, -- Support patterns like file:line:col
        cwd_bonus = false, -- Bonus for items in current directory
      },
      picker = {
        ui_select = true,
        prompt = ' ',
        formatters = {
          file = {
            filename_first = false, -- display filename before the file path
            truncate = 100, -- truncate the file path to (roughly) this length
            filename_only = false, -- only show the filename
            icon_width = 2, -- width of the icon (in characters)
            git_status_hl = true, -- use the git status highlight group for the filename
          },
        },
        previewers = {
                           git = {
                               native = true,
                           },
        },
        win = {
                           input = {
                               keys = {
                                   -- ['<Tab>'] = { 'list_down', mode = { 'i', 'n' } },
                                   -- ['<S-Tab>'] = { 'list_up', mode = { 'i', 'n' } },
                                   ['<c-x>'] = { 'edit_split', mode = { 'i', 'n' } },
                                   ['<c-u>'] = {
                                       'preview_scroll_up',
                                       mode = { 'i', 'n' },
                                   },
                                   ['<c-d>'] = {
                                       'preview_scroll_down',
                                       mode = { 'i', 'n' },
                                   },
                               },
                           },
                       },
        sources = {
          explorer = {
            auto_close = false,
            hidden = true,
            follow_file = true,
            tree = true,
            focus = "list",
            replace_netrw = true,
            --jump = { close = false },
            layout = {
              --preset = "list",
              preview = false,
            },
            win = {
                         list = {
                           keys = {
                             ["."] = "explorer_focus",
                           },
                         },
                       },
            actions = {
              copy_file_path = {
                action = function(_, item)
                  if not item then return end

                  local vals = {
                    ["BASENAME"] = vim.fn.fnamemodify(item.file, ":t:r"),
                    ["EXTENSION"] = vim.fn.fnamemodify(item.file, ":t:e"),
                    ["FILENAME"] = vim.fn.fnamemodify(item.file, ":t"),
                    ["PATH"] = item.file,
                    ["PATH (CWD)"] = vim.fn.fnamemodify(item.file, ":."),
                    ["PATH (HOME)"] = vim.fn.fnamemodify(item.file, ":~"),
                    ["URI"] = vim.uri_from_fname(item.file),
                  }

                  local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
                  if vim.tbl_isempty(options) then
                    vim.notify("No values to copy", vim.log.levels.WARN)
                    return
                  end
                  table.sort(options)
                  vim.ui.select(options, {
                    prompt = "Choose to copy to clipboard:",
                    format_item = function(list_item) return ("%s: %s"):format(list_item, vals[list_item]) end,
                  }, function(choice)
                    local result = vals[choice]
                    if result then
                      vim.fn.setreg("+", result)
                      Snacks.notify.info("Yanked `" .. result .. "`")
                    end
                  end)
                end,
              },
              search_in_directory = {
                action = function(_, item)
                  if not item then return end
                  local dir = vim.fn.fnamemodify(item.file, ":p:h")
                  Snacks.picker.grep {
                    cwd = dir,
                    cmd = "rg",
                    args = {
                      "-g",
                      "!.git",
                      "-g",
                      "!node_modules",
                      "-g",
                      "!dist",
                      "-g",
                      "!build",
                      "-g",
                      "!coverage",
                      "-g",
                      "!.DS_Store",
                      "-g",
                      "!.docusaurus",
                      "-g",
                      "!.dart_tool",
                    },
                    show_empty = true,
                    hidden = true,
                    ignored = true,
                    follow = false,
                    supports_live = true,
                  }
                end,
              },
              diff = {
                action = function(picker)
                  picker:close()
                  local sel = picker:selected()
                  if #sel > 0 and sel then
                    Snacks.notify.info(sel[1].file)
                    vim.cmd("tabnew " .. sel[1].file)
                    vim.cmd("vert diffs " .. sel[2].file)
                    Snacks.notify.info("Diffing " .. sel[1].file .. " against " .. sel[2].file)
                    return
                  end

                  Snacks.notify.info "Select two entries for the diff"
                end,
              },
            },
            win = {
              list = {
                keys = {
                  ["y"] = "copy_file_path",
                  ["s"] = "search_in_directory",
                  ["D"] = "diff",
                },
              },
            },
          },
          projects = {
            finder = "recent_projects",
            layout = "vscode",
            format = "file",
            dev = { "~/.local/src" },
            patterns = { "=src", ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile", "config" },
            confirm = "load_session",
            --confirm = function(picker, item)
            --  picker:close()
            --  if item then
            --    vim.schedule(function()
            --      Snacks.picker.recent {
            --        filter = {
            --          cwd = Snacks.git.get_root(item.text),
            --        },
            --        finder = "recent_files",
            --        format = "file",
            --      }
            --    end)
            --  end
            --end,
            -- patterns = {},
            recent = true,
            matcher = {
              frecency = false,
              sort_empty = false,
              cwd_bonus = false,
            },
            -- sort = { fields = { "score:desc", "idx" } },
            projects = {
              -- "~/.local/src/datagrip",
            },
            win = {
              preview = { minimal = true },
              input = {
                keys = {
                  -- every action will always first change the cwd of the current tabpage to the project
                  ["<c-e>"] = { { "tcd", "picker_explorer" }, mode = { "n", "i" } },
                  ["<c-f>"] = { { "tcd", "picker_files" }, mode = { "n", "i" } },
                  ["<c-g>"] = { { "tcd", "picker_grep" }, mode = { "n", "i" } },
                  ["<c-r>"] = { { "tcd", "picker_recent" }, mode = { "n", "i" } },
                  ["<c-w>"] = { { "tcd" }, mode = { "n", "i" } },
                  ["<CR>"] = { { "tcd", "close" }, mode = { "n", "i" } },
                  ["<c-t>"] = {
                    function(picker)
                      vim.cmd "tabnew"
                      Snacks.notify "New tab opened"
                      picker:close()
                      Snacks.picker.projects()
                    end,
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        },
      },
      explorer = {},
    },
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- { "<leader>f/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>f/", function() Snacks.picker.lines() end, desc = "Buffer lines" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      -- { '<C-e>', function() Snacks.explorer.reveal() end },
      {
          "<leader>e",
          function()
            local explorer_pickers = Snacks.picker.get({ source = "explorer" })
            for _, v in pairs(explorer_pickers) do
              if v:is_focused() then
                v:close()
              else
                v:focus()
              end
            end
            if #explorer_pickers == 0 then
              Snacks.picker.explorer()
            end
          end,
        },
      {
          "<leader>o",
          function()
            local explorer_pickers = Snacks.picker.get({ source = "explorer" })
            for _, v in pairs(explorer_pickers) do
              if v:is_focused() then
                v:close()
              else
                v:focus()
              end
            end
            if #explorer_pickers == 0 then
              Snacks.picker.explorer()
            end
          end,
        },
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      {
        "<leader>fc",
        function() Snacks.picker.files { cwd = vim.fn.stdpath "config" } end,
        desc = "Find Config File",
      },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<C-p>", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      {
        "<leader>sw", -- <leader>*
        function() Snacks.picker.grep_word() end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      --{ "<leader>e", function()
      --    Snacks.explorer()
      --    vim.schedule(function()
      --      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('.', true, false, true), 'n', false)
      --      end)
      --  end,
      --    desc = "Focus File Explorer"
      --  },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

      { "<leader>r", function() Snacks.picker.resume() end, desc = "Snacks Resume" },
      -- { "<leader>F", function() Snacks.zen.zoom() end, desc = "Zoom Window" },
      { "<C-H>", function() Snacks.zen.zen() end, desc = "Zoom Window" },
      --{ "<leader>S", function() Snacks.picker() end, desc = "Snacks Pickers" },
    },
  },
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   ---@type Flash.Config
  --   opts = {},
  --   -- stylua: ignore
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --     { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --     { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --     { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --     { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   },
  -- }
}
