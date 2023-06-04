return {
  {
    "iamcco/markdown-preview.nvim",
    build = "pnpm up && cd app && pnpm install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
}
