---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    enabled = true,
    opts = {
      matcher = {
        fuzzy = true,
        ignorecase = true,
        smartcase = true,
        sort_empty = false,
        file_pos = true, -- Support patterns like file:line:col
        cwd_bonus = false, -- Bonus for items in current directory
      },
      image = {
        -- force = true,
        -- img_dirs = { "assets" },
        doc = {
          -- enable image viewer for documents
          -- a treesitter parser must be available for the enabled languages.
          enabled = true,
          -- render the image inline in the buffer
          -- if your env doesn't support unicode placeholders, this will be disabled
          -- takes precedence over `opts.float` on supported terminals
          inline = true,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          float = true,
          max_width = 80,
          max_height = 40,
          -- Set to `true`, to conceal the image text when rendering inline.
          -- (experimental)
          ---@param lang string tree-sitter language
          ---@param type snacks.image.Type image type
          conceal = function(lang, type)
            -- only conceal math expressions
            return type == "math"
          end,
        },
        resolve = function(path, src)
          if require("obsidian.api").path_is_note(path) then return require("obsidian.api").resolve_image_path(src) end
        end,
        debug = {
          request = false,
          convert = false,
          placement = false,
        },
      },
      picker = {
        ui_select = true,
        prompt = " ",
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
              ["<c-x>"] = { "edit_split", mode = { "i", "n" } },
              ["<c-u>"] = {
                "preview_scroll_up",
                mode = { "i", "n" },
              },
              ["<c-d>"] = {
                "preview_scroll_down",
                mode = { "i", "n" },
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
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
          Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
          Snacks.toggle.diagnostics():map "<leader>ud"
          Snacks.toggle.line_number():map "<leader>ul"
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map "<leader>uc"
          Snacks.toggle.treesitter():map "<leader>uT"
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>ub"
          Snacks.toggle.inlay_hints():map "<leader>uh"
          Snacks.toggle.indent():map "<leader>ug"
          Snacks.toggle.dim():map "<leader>uD"
        end,
      })
    end,
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { ";x", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { ";w", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>f/", function() Snacks.picker.lines() end, desc = "Buffer lines" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      {
        "<leader>e",
        function()
          local explorer_pickers = Snacks.picker.get { source = "explorer" }
          for _, v in pairs(explorer_pickers) do
            if v:is_focused() then
              v:close()
            else
              v:focus()
            end
          end
          if #explorer_pickers == 0 then Snacks.picker.explorer() end
        end,
      },
      {
        "<leader>o",
        function()
          local explorer_pickers = Snacks.picker.get { source = "explorer" }
          for _, v in pairs(explorer_pickers) do
            if v:is_focused() then
              v:close()
            else
              v:focus()
            end
          end
          if #explorer_pickers == 0 then Snacks.picker.explorer() end
        end,
      },
      { ";s", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { ";l", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { ";d", function() Snacks.dim() end, desc = "dim active scope" },
      { ";D", function() Snacks.dim.disable() end, desc = "dim active scope" },
      { ";e", function() Snacks.explorer.reveal() end, desc = "dim active scope" },

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
      -- { "<C-E>", function() Snacks.image.hover() end, desc = "Zoom Window" },
      { "<C-E>", function() Snacks.image.health() end, desc = "Zoom Window" },

      { "<C-H>", function() Snacks.zen.zen() end, desc = "Zoom Window" },
      --{ "<leader>S", function() Snacks.picker() end, desc = "Snacks Pickers" },
    },
  },
}
