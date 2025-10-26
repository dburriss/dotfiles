return {
  {
    "wintermute-cell/gitignore.nvim",
    keys = {
      { "<leader>gi", "<cmd>Gitignore<cr>", desc = "Gitignore" },
    },
    config = function()
      require("gitignore")
    end,
  },
}
