return {
  "goolord/alpha-nvim",
  opts = function(_, opts) -- override the options using lazy.nvim
    opts.section.header.val = { -- change the header section value
    }
    opts.section.buttons.val = {
      --     opts.button("h", "  Say Hi", ':echo "Hello World!"<CR>'),
    }
  end,
}
