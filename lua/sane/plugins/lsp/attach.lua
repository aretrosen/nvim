local M = {}
M.navic_once = true
M.on_attach = function(client, bufnr)
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting." .. bufnr, {}),
      buffer = bufnr,
      callback = function()
        if vim.b[bufnr].nofmt then
          return
        end
        local have_nls = #require("null-ls.sources").get_available(
          vim.bo[bufnr].filetype,
          "NULL_LS_FORMATTING"
        ) > 0
        print(have_nls)
        vim.lsp.buf.format {
          bufnr = bufnr,
          timeout_ms = 1000,
          filter = function(cli)
            if have_nls then
              return cli.name == "null-ls"
            end
            return cli.name ~= "null-ls"
          end,
        }
      end,
    })
  end

  if M.navic_once and client.supports_method "textDocument/documentSymbol" then
    M.navic_once = false
    require("nvim-navic").attach(client, bufnr)
  end

  local buf_map = function(key, func, desc, opts)
    opts = opts or {}
    opts.mode = opts.mode or "n"
    if not opts.has or client.server_capabilities[opts.has .. "Provider"] then
      vim.keymap.set(opts.mode, key, func, { silent = true, buffer = bufnr, desc = desc })
    end
  end
  buf_map("gD", vim.lsp.buf.declaration, "LSP Declaration")
  buf_map("gd", "<cmd>Telescope lsp_definitions<cr>", "LSP Definition", { has = "definition" })
  buf_map("K", vim.lsp.buf.hover, "LSP Hover")
  buf_map("gK", vim.lsp.buf.signature_help, "LSP Signature Help", { has = "signatureHelp" })
  buf_map("gI", "<cmd>Telescope lsp_implementations<cr>", "LSP Implementation")
  buf_map("gr", "<cmd>Telescope lsp_references<cr>", "LSP References")
  buf_map("<leader>D", "<cmd>Telescope lsp_type_definitions<cr>", "LSP Type Definitions")
  buf_map("<leader>nf", function()
    local buf = vim.api.nvim_get_current_buf()
    vim.b[buf].nofmt = not vim.b[buf].nofmt
    vim.notify("Formatting on Save: " .. tostring(not vim.b[buf].nofmt), vim.log.levels.INFO)
  end, "Toggle autoformatting")
  buf_map(
    "<leader>ca",
    vim.lsp.buf.code_action,
    "LSP Code Actions",
    { mode = { "n", "v" }, has = "codeAction" }
  )
  vim.keymap.set("n", "<leader>rn", function()
    return ":IncRename " .. vim.fn.expand "<cword>"
  end, {
    desc = "LSP Incremental Rename",
    expr = true,
    buffer = bufnr,
  })
  buf_map("<leader>ld", vim.diagnostic.open_float, "Line Diagnostics")
  buf_map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
  buf_map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
end
return M
