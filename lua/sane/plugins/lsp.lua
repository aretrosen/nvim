return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", config = true },
      "nvim-navic",
      "mason.nvim",
      "clangd_extensions.nvim",
      "rust-tools.nvim",
      "b0o/SchemaStore.nvim",
      "barreiroleo/ltex-extra.nvim",
      -- "haskell-tools.nvim",
      "typescript.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {
          window = {
            blend = 0,
          },
        },
      },
      "williamboman/mason-lspconfig.nvim",
      "cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "awk_ls",
          "ansiblels",
          -- "astro",
          "bashls",
          "cmake",
          "elixirls",
          "gopls",
          -- "golangci_lint_ls",
          "html",
          "tsserver",
          "lua_ls",
          "ltex",
          "marksman",
          -- "texlab",
          "pyright",
          -- "solang",
          "svelte",
          -- "svlangserver",
          "tailwindcss",
          "taplo",
          "jsonls",
          "wgsl_analyzer",
          -- "yamlls",
        },
      }

      local cmp_capabilities =
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = "rounded",
        })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.fn.sign_define("LightBulbSign", { text = "💡" })
      vim.b.lightbulb = nil

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = vim.api.nvim_create_augroup("LightBulb", {}),
        desc = "Code Action Indicator",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local code_action_cap_found = false
          for _, client in pairs(vim.lsp.get_active_clients { bufnr = bufnr }) do
            if client and client.supports_method "textDocument/codeAction" then
              code_action_cap_found = true
              break
            end
          end
          if not code_action_cap_found then
            return
          end
          local params = vim.lsp.util.make_range_params()
          params.context =
            { diagnostics = vim.diagnostic.get(bufnr, { lnum = params.range.start.line }) }
          vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", params, function(responses)
            local new_line = params.range.start.line + 1
            local has_actions = false
            for _, response in pairs(responses) do
              if response.result and not vim.tbl_isempty(response.result) then
                has_actions = true
                break
              end
            end
            if vim.b.lightbulb then
              vim.fn.sign_unplace("lsp_lightbulb", { id = vim.b.lightbulb, buffer = bufnr })
              vim.b.lightbulb = nil
            end
            if has_actions and vim.b.lightbulb ~= new_line then
              vim.fn.sign_place(
                new_line,
                "lsp_lightbulb",
                "LightBulbSign",
                bufnr,
                { lnum = new_line, priority = 10 }
              )
              vim.b.lightbulb = new_line
            end
          end)
        end,
      })

      local custom_attach = function(client, bufnr)
        if client.supports_method "textDocument/formatting" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LspFormatting." .. bufnr, {}),
            buffer = bufnr,
            callback = function()
              local have_nls = #require("null-ls.sources").get_available(
                vim.bo[bufnr].filetype,
                "NULL_LS_FORMATTING"
              ) > 0
              vim.lsp.buf.format {
                bufnr = bufnr,
                timeout_ms = 2000,
                filter = function(cli)
                  return have_nls and cli.name == "null-ls"
                end,
              }
            end,
          })
        end

        if client.supports_method "textDocument/documentSymbol" then
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
        buf_map("gd", "<cmd>Telescope lsp_definitions<cr>", "LSP Definition")
        buf_map("K", vim.lsp.buf.hover, "LSP Hover")
        buf_map("gK", vim.lsp.buf.signature_help, "LSP Signature Help", { has = "signatureHelp" })
        buf_map("gI", "<cmd>Telescope lsp_implementations<cr>", "LSP Implementation")
        buf_map("gr", "<cmd>Telescope lsp_references<cr>", "LSP References")
        buf_map("<leader>D", "<cmd>Telescope lsp_type_definitions<cr>", "LSP Type Definitions")
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

      local diag_ico = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      for name, icon in pairs(diag_ico) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config {
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      }

      local lspcfg = require "lspconfig"

      lspcfg["awk_ls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["ansiblels"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["lua_ls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      }

      lspcfg["bashls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["cmake"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["elixirls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["html"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["ltex"].setup {
        on_attach = function(client, bufnr)
          require("ltex_extra").setup {
            load_langs = { "es-AR", "en-US" },
            init_check = true,
            path = vim.fn.stdpath "config" .. "/dictionaries",
          }
          custom_attach(client, bufnr)
        end,
        capabilities = cmp_capabilities,
      }

      lspcfg["marksman"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["perlnavigator"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
        settings = {
          perlnavigator = {
            enableWarnings = true,
            perltidyProfile = "",
            perlcriticProfile = "",
            perlcriticEnabled = true,
          },
        },
      }

      lspcfg["svelte"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["taplo"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["jsonls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }

      lspcfg["pyright"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["tailwindcss"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["wgsl_analyzer"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["gopls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
        init_options = {
          usePlaceholders = true,
        },
        settings = {
          gopls = {
            allExperiments = true,
            gofumpt = true,
            analyses = {
              unusedparams = true,
              fieldalignment = true,
              nilness = true,
              shadow = true,
            },
            staticcheck = true,
          },
        },
      }

      require("typescript").setup {
        server = {
          on_attach = function(client, bufnr)
            vim.keymap.set(
              "n",
              "<leader>co",
              "TypescriptOrganizeImports",
              { buffer = bufnr, desc = "Organize Imports" }
            )
            vim.keymap.set(
              "n",
              "<leader>cR",
              "TypescriptRenameFile",
              { desc = "Rename File", buffer = bufnr }
            )
            custom_attach(client, bufnr)
          end,
          capabilities = cmp_capabilities,
        },
      }

      -- local ht = require "haskell-tools"
      -- ht.setup {
      --   hls = {
      --     on_attach = function(client, bufnr)
      --       vim.keymap.set(
      --         "n",
      --         "<space>cl",
      --         vim.lsp.codelens.run,
      --         { silent = true, buffer = bufnr }
      --       )
      --       vim.keymap.set(
      --         "n",
      --         "<space>hs",
      --         ht.hoogle.hoogle_signature,
      --         { silent = true, buffer = bufnr }
      --       )
      --       custom_attach(client, bufnr)
      --     end,
      --     capabilities = cmp_capabilities,
      --   },
      -- }

      local rt = require "rust-tools"
      rt.setup {
        server = {
          on_attach = function(client, bufnr)
            vim.keymap.set(
              "n",
              "K",
              rt.hover_actions.hover_actions,
              { buffer = bufnr, desc = "Rust Hover Action" }
            )
            vim.keymap.set(
              "n",
              "<Leader>ca",
              rt.code_action_group.code_action_group,
              { buffer = bufnr, desc = "Rust Code Actions" }
            )
            custom_attach(client, bufnr)
          end,
          capabilities = cmp_capabilities,
          cmd = { "rustup", "run", "nightly", "rust-analyzer" },
          settings = {
            ["rust-analyzer"] = {
              rustfmt = { extraArgs = "+nightly" },
              checkOnSave = {
                command = "clippy",
              },
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
              cargo = {
                allFeatures = true,
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }

      require("clangd_extensions").setup {
        server = {
          on_attach = function(client, bufnr)
            vim.keymap.set(
              "n",
              "<leader>cs",
              "<cmd>ClangdSwitchSourceHeader<cr>",
              { buffer = bufnr, desc = "Switch between Source and Header" }
            )
            custom_attach(client, bufnr)
          end,
          capabilities = cmp_capabilities,
          settings = {
            cmd = {
              "clangd",
              "--background-index",
              "--suggest-missing-includes",
              "--clang-tidy",
              "--header-insertion=iwyu",
            },
          },
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      local ensure_installed = {
        "eslint_d",
        "shellcheck",
        "flake8",
        "black",
        "isort",
        "gofumpt",
        "perlnavigator",
        "prettierd",
        "shellharden",
        "shfmt",
        "stylua",
      }
      local mr = require "mason-registry"
      for _, tool in ipairs(ensure_installed) do
        local ok, p = pcall(mr.get_package, tool)
        if ok and not p:is_installed() then
          p:install()
        end
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim", "typescript.nvim", "ts-node-action" },
    config = function()
      local nls = require "null-ls"
      nls.register {
        name = "more_actions",
        method = { nls.methods.CODE_ACTION },
        filetypes = { "_all" },
        generator = {
          fn = require("ts-node-action").available_actions,
        },
      }
      nls.setup {
        debounce = 150,
        sources = {
          nls.builtins.diagnostics.eslint_d,
          nls.builtins.code_actions.eslint_d,
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.code_actions.shellcheck,
          nls.builtins.diagnostics.flake8,
          nls.builtins.formatting.black,
          nls.builtins.formatting.isort,
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.shellharden,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
          require "typescript.extensions.null-ls.code-actions",
        },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      {
        "<leader>td",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "Document Diagnostics (Trouble)",
      },
      {
        "<leader>wd",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
    },
    opts = { use_diagnostic_signs = true },
  },
  "simrat39/rust-tools.nvim",
  "p00f/clangd_extensions.nvim",
  "mrcjkb/haskell-tools.nvim",
  "jose-elias-alvarez/typescript.nvim",
}
