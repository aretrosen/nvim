local api = vim.api
local npcall = vim.F.npcall

local default_opts = {
  sign = "💡",
  signhl = "LspInfoList",
  priority = 10,
}

local M = { code_action_capability = nil }

local check_code_action_availabilty = function(bufnr)
  for _, client in pairs(vim.lsp.get_active_clients { bufnr = bufnr }) do
    if client and client.supports_method "textDocument/codeAction" then
      M.code_action_capability = client.id
      return true
    end
  end
  return false
end

local remove_lightbulb = function(bufnr)
  if M.lightbulb then
    npcall(api.nvim_buf_clear_namespace, bufnr, M.ns, M.lightbulb, M.lightbulb + 1)
    M.lightbulb = nil
  end
end

M.setup = function(opts)
  opts = opts or {}
  opts = vim.tbl_extend("force", default_opts, opts)

  M.lightbulb = nil
  M.ns = api.nvim_create_namespace "lsp-lightbulb"

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("LightBulb", {}),
    desc = "Code Action Indicator",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      if not M.code_action_capability or not vim.lsp.get_client_by_id(M.code_action_capability) then
        remove_lightbulb(bufnr)
        if not check_code_action_availabilty(bufnr) then
          return
        end
      end

      local params = vim.lsp.util.make_range_params()
      local new_line = params.range.start.line
      params.context = { diagnostics = vim.diagnostic.get(bufnr, { lnum = new_line }) }

      vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(responses)
        remove_lightbulb(bufnr)
        local has_actions = false

        for _, response in pairs(responses) do
          if response.result and not vim.tbl_isempty(response.result) then
            has_actions = true
            break
          end
        end

        if has_actions and M.lightbulb ~= new_line then
          npcall(api.nvim_buf_set_extmark, bufnr, M.ns, new_line, -1, {
            id = new_line,
            sign_text = opts.sign,
            priority = opts.priority,
            sign_hl_group = opts.signhl,
          })
          M.lightbulb = new_line
        end
      end)
    end,
  })
end

return M
