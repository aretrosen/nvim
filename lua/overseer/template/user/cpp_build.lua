return {
  name = "g++ build",
  builder = function()
    local infile = vim.fn.expand "%:p"
    local outfile = vim.fn.expand "%:p:r"
    return {
      cmd = { "g++" },
      args = { "-std=c++20", "-O2", "-Wall", "-Wextra", infile, "-o", outfile },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
