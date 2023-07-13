return {
  {
    "asiryk/auto-hlsearch.nvim",
    keys = { "/", "?", "*", "#", "n", "N" },
    config = true,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = true,
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    config = true,
  },
}
