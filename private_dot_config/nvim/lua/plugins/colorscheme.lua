return {
  -- install Monokai
  -- { "loctvl842/monokai-pro.nvim" },
  -- install tokionight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      style = "moon",
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      -- param highlights tokionight.Highlights
      -- param colors tokyonight.ColorScheme
      --   on_highlights = function(highlights, colors)
      --     highlights.Cursor = {
      --       bg = "#c0caf5",
      --       fg = "#FFFFFF",
      --     }
      --   end,
    },
  },
  -- configure
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
