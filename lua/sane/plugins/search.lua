return {
  {
    "asiryk/auto-hlsearch.nvim",
    keys = { "/", "?", "*", "#", "n", "N" },
    config = true,
  },
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "v", "o" } },
      { "S", mode = { "n", "v", "o" } },
      { "x", mode = { "v", "o" } },
      { "X", mode = { "v", "o" } },
      "gs",
    },
    event = "VeryLazy",
    dependencies = { { "ggandor/flit.nvim", opts = { labeled_modes = "nv" } } },
    config = function()
      require("leap").add_default_mappings(true)
    end,
  },
}
