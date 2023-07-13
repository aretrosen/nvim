local fn = vim.fn
local ok, perlprefix = pcall(fn.system, { "plenv", "prefix" })
local perlversion = ""
if ok then
  perlprefix = vim.trim(perlprefix)
  perlversion = fn.fnamemodify(perlprefix, ":t")
end

local diag_icons = {
  Error = " ",
  Warn = " ",
  Hint = "󰌵 ",
  Info = " ",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      {
        "folke/neodev.nvim",
        config = true,
      },
      { "smjonas/inc-rename.nvim", cmd = "IncRename", opts = { input_buffer_type = "dressing" } },
      "mason.nvim",
      "clangd_extensions.nvim",
      "rust-tools.nvim",
      "b0o/SchemaStore.nvim",
      "barreiroleo/ltex-extra.nvim",
      "yaml-companion.nvim",
      "typescript-tools.nvim",
      "scalameta/nvim-metals",
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = {
          window = {
            blend = 10,
          },
        },
      },
      "williamboman/mason-lspconfig.nvim",
      "cmp-nvim-lsp",
    },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          -- "asm_lsp",
          -- "astro",
          -- "awk_ls",
          -- "bashls",
          -- "dockerls",
          "elixirls",
          -- "eslint",
          -- "gopls",
          -- "html",
          -- "jsonls",
          "ltex",
          "lua_ls",
          -- "neocmake",
          "perlnavigator",
          -- "prismals",
          -- "pyright",
          -- "ruff_lsp",
          -- "tailwindcss",
          -- "taplo",
          -- "texlab",
          -- "tsserver",
          "verible",
          -- "wgsl_analyzer",
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

      local custom_attach = require("sane.plugins.lsp.attach").on_attach

      for name, icon in pairs(diag_icons) do
        name = "DiagnosticSign" .. name
        fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config {
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          severity = { min = vim.diagnostic.severity.WARN },
        },
        severity_sort = true,
        float = { border = "rounded", source = "always" },
      }

      local map = vim.keymap.set
      map(
        "n",
        "<leader>ld",
        vim.diagnostic.open_float,
        { silent = true, desc = "Line Diagnostics" }
      )
      map("n", "[d", vim.diagnostic.goto_prev, { silent = true, desc = "Previous Diagnostic" })
      map("n", "]d", vim.diagnostic.goto_next, { silent = true, desc = "Next Diagnostic" })

      local lspcfg = require "lspconfig"

      lspcfg["ansiblels"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["asm_lsp"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["astro"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["awk_ls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["bashls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
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
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=google",
            },
          },
        },
        extensions = {
          ast = {
            role_icons = {
              type = "",
              declaration = "",
              expression = "",
              specifier = "",
              statement = "",
              ["template argument"] = "",
            },

            kind_icons = {
              Compound = "",
              Recovery = "",
              TranslationUnit = "",
              PackExpansion = "",
              TemplateTypeParm = "",
              TemplateTemplateParm = "",
              TemplateParamObject = "",
            },
          },
        },
      }

      lspcfg["docker_compose_language_service"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["dockerls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["elixirls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["eslint"].setup {
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              if require("lspconfig.util").get_active_client_by_name(event.buf, "eslint") then
                vim.cmd "EslintFixAll"
              end
            end,
          })
          custom_attach(client, bufnr)
        end,
        capabilities = cmp_capabilities,
        settings = {
          experimental = {
            useFlatConfig = true,
          },
          packageManager = "pnpm",
          workingDirectory = {
            mode = "auto",
          },
        },
      }

      lspcfg["fortls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
        cmd = {
          "fortls",
          "--lowercase_intrisics",
          "--hover_signature",
          "--hover_language=fortran",
          "--use_signature_help",
        },
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
            semanticTokens = true,
            analyses = {
              unusedparams = true,
              unusedwrite = true,
              unusedvariable = true,
              fieldalignment = true,
              nilness = true,
              shadow = true,
              useany = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            staticcheck = true,
          },
        },
      }

      lspcfg["html"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["jsonls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            format = { enable = true },
            validate = { enable = true },
          },
        },
      }

      lspcfg["ltex"].setup {
        on_attach = function(client, bufnr)
          require("ltex_extra").setup {
            load_langs = { "es", "en-US" },
            init_check = true,
            path = fn.stdpath "config" .. "/dictionaries",
          }
          custom_attach(client, bufnr)
        end,
        capabilities = cmp_capabilities,
        settings = {
          ltex = {
            diagnosticSeverity = "warning",
          },
        },
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

      lspcfg["neocmake"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["ocamllsp"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
        get_language_id = function(_, ftype)
          return ftype
        end,
      }

      lspcfg["perlnavigator"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
        settings = {
          perlnavigator = {
            perlPath = vim.trim(fn.system { "plenv", "which", "perl" }),
            enableWarnings = true,
            perltidyProfile = "",
            perlcriticProfile = "",
            perlcriticEnabled = true,
            includePaths = {
              perlprefix .. "/lib/perl5/" .. perlversion,
              perlprefix .. "/lib/perl5/site_perl/" .. perlversion,
            },
          },
        },
      }

      lspcfg["prismals"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["pyright"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["ruff_lsp"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

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

      lspcfg["tailwindcss"].setup {
        on_attach = custom_attach,
        filetypes = {
          "astro",
          "astro-markdown",
          "eelixir",
          "elixir",
          "html",
          "html-eex",
          "heex",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "rescript",
          "typescript",
          "typescriptreact",
          "vue",
        },
        capabilities = cmp_capabilities,
      }

      lspcfg["taplo"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["texlab"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
        settings = {
          texlab = {
            build = {
              args = {
                "-xelatex",
                "-file-line-error",
                "-synctex=1",
                "-interaction=nonstopmode",
                "%f",
              },
              forwardSearchAfter = true,
              onSave = true,
            },
            chktex = {
              onOpenAndSave = true,
              onEdit = true,
            },
            forwardSearch = {
              executable = "zathura",
              args = {
                "--synctex-forward",
                "%l:1:%f",
                "%p",
              },
            },
          },
        },
      }

      require("typescript-tools").setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["verible"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["wgsl_analyzer"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      lspcfg["yamlls"].setup(require("yaml-companion").setup {
        lspconfig = {
          on_attach = custom_attach,
          capabilities = cmp_capabilities,
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              },
            },
          },
        },
      })

      lspcfg["zls"].setup {
        on_attach = custom_attach,
        capabilities = cmp_capabilities,
      }

      -- nvim-metals
      local metals_config = require("metals").bare_config()
      metals_config.on_attach = custom_attach
      metals_config.handlers = {
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = "rounded",
        }),
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",
        }),
      }

      metals_config.settings = {
        showImplicitArguments = true,
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = vim.api.nvim_create_augroup("nvim-metals", { clear = true }),
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = true,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
    },
    config = function()
      local nls = require "null-ls"
      nls.setup {
        debounce = 150,
        on_attach = require("sane.plugins.lsp.attach").on_attach,
        sources = {
          -- nls.builtins.diagnostics.cppcheck,
          nls.builtins.formatting.black,
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.shellharden,
          -- HACK: bashls code_actions currently not working
          nls.builtins.code_actions.shellcheck,
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.hadolint,
          nls.builtins.formatting.stylua,
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
  {
    -- dir = "~/.config/nvim/lua_plugins/lightbulb.nvim",
    "kosayoda/nvim-lightbulb",
    event = "VeryLazy",
    config = true,
  },
  "simrat39/rust-tools.nvim",
  "p00f/clangd_extensions.nvim",
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "plenary.nvim" },
  },
  {
    "saecki/crates.nvim",
    event = { "BufReadPost Cargo.toml" },
    opts = {
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    },
  },
}
