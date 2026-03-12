return {
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
  }
