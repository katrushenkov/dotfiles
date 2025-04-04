--if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.motion.hop-nvim" },
  --{ import = "astrocommunity.note-taking.neorg" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.colorscheme.everforest" },
  -- { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  -- { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  --{ import = "astrocommunity.recipes.heirline-clock-statusline" },
  --{ import = "astrocommunity.recipes.heirline-mode-text-statusline" },
  -- import/override with your plugins folder
}
