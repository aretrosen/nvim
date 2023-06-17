local M = {}
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

  local map = vim.keymap.set
  local aug = vim.api.nvim_create_augroup
  local acmd = vim.api.nvim_create_autocmd

  local buf_map = function(key, func, desc, opts)
    opts = opts or {}
    opts.mode = opts.mode or "n"
    if not opts.has or client.server_capabilities[opts.has .. "Provider"] then
      map(opts.mode, key, func, { silent = true, buffer = bufnr, desc = desc })
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
  map("n", "<leader>rn", function()
    return ":IncRename " .. vim.fn.expand "<cword>"
  end, {
    desc = "LSP Incremental Rename",
    expr = true,
    buffer = bufnr,
  })

  if client.server_capabilities.documentHighlightProvider then
    local agdh = aug("LSPDocumentHighlight." .. bufnr, {})
    acmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = agdh,
    })
    acmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = agdh,
    })
  end

  if false and client.server_capabilities.codeLensProvider then
    local agcl = aug("LSPCodeLens." .. bufnr, {})
    acmd("BufEnter", {
      callback = vim.lsp.codelens.refresh,
      buffer = bufnr,
      once = true,
      group = agcl,
    })
    acmd({ "BufWritePost", "CursorHold" }, {
      callback = vim.lsp.codelens.refresh,
      buffer = bufnr,
      group = agcl,
    })
  end
end
return M
