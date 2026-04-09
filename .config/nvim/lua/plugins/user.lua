return {
  {
      'MeanderingProgrammer/render-markdown.nvim',
      version = false,
      enabled = true,
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },
      ---@module 'render-markdown'
      ---@type render.md.UserConfig
      opts = {
        anti_conceal = {
             enabled = true,
             disabled_modes = true,
             ignore = {
              code_background = true,
              code_language = true,
              code_border = false,
              indent = true,
              sign = true,
              virtual_lines = true,
          },
      },
        code = {
          border = 'none',
          render_modes = true,
          style = 'full',
          sign = false,
          conceal_delimiters = true,

      },
        heading = {
               width = 'block',
               left_pad = 0,
               right_pad = 4,
               backgrounds = {
                          '',
                          '',
                          '',
                          '',
                          '',
                          'RenderMarkdownH6Bg',
                      },
           },
      },
  },
  {
    "ramilito/kubectl.nvim",
    version = "2.*",
    dependencies = "saghen/blink.download",
    config = function()
      require("kubectl").setup()
    end,
  },
  {
    "obsidian-nvim/obsidian.nvim",
    enabled = true,
    version = false,
    lazy = true,
    ft = "markdown",
    opts = {
      legacy_commands = false,
      ui = {
        enable = false,
      },
      keys = {
        { '<leader>ob', '<cmd>Obsidian backlinks<cr>', desc = '[O]bisidan [B]acklinks' },
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
      attachments = {
        folder = "obsidian/_resources",
        --img_text_func = require("obsidian.builtin").img_text_func,
        --img_name_func = function() return string.format("%s", os.date "%Y%m%d%H%M%S", vim.fn.rand() % 10000) end,
        img_name_func = function() return string.format("%s", os.date "%Y%m%d%H%M%S") end,
        confirm_img_paste = false,
      },
      workspaces = {
        {
          name = "anima",
          path = "$HOME/.local/src/anima",
        },
        {
          name = "datagrip",
          path = "$HOME/.local/src/datagrip",
        },
      },
    },
  },
  { "nvim-mini/mini.pairs", enabled = false },
  { "folke/persistence.nvim", enabled = false },
}
