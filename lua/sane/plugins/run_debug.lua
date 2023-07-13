local fn = vim.fn
local dap_icons = {
  Breakpoint = { "", "DiagnosticSignError" },
  BreakpointCondition = { "", "DiagnosticSignInfo" },
  Stopped = { "󰁕", "DiagnosticSignOk" },
  BreakpointRejected = { "", "DiagnosticSignWarn" },
  LogPoint = { "", "DiagnosticSignHint" },
}

return {
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin", "user.cpp_build" },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          {
            "<leader>du",
            function()
              require("dapui").toggle {}
            end,
            desc = "Dap UI",
          },
          {
            "<leader>de",
            function()
              require("dapui").eval()
            end,
            desc = "Eval",
            mode = { "n", "v" },
          },
        },
        config = function()
          local dap = require "dap"
          local dapui = require "dapui"
          dapui.setup {}
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open {}
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close {}
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close {}
          end
        end,
      },
      { "theHamsta/nvim-dap-virtual-text", config = true },
      {
        "mfussenegger/nvim-dap-python",
        keys = {
          {
            "<leader>dPt",
            function()
              require("dap-python").test_method()
            end,
            desc = "Debug Method",
          },
          {
            "<leader>dPc",
            function()
              require("dap-python").test_class()
            end,
            desc = "Debug Class",
          },
        },
        config = function()
          local path = require("mason-registry").get_package("debugpy"):get_install_path()
          require("dap-python").setup(path .. "/venv/bin/python")
        end,
      },
      {
        "jbyuki/one-small-step-for-vimkind",
        keys = {
          {
            "<leader>daL",
            function()
              require("osv").launch { port = 8086 }
            end,
            desc = "Adapter Lua Server",
          },
          {
            "<leader>dal",
            function()
              require("osv").run_this()
            end,
            desc = "Adapter Lua",
          },
        },
        config = function()
          local dap = require "dap"
          dap.adapters.nlua = function(callback, config)
            callback {
              type = "server",
              host = "127.0.0.1",
              port = 8086,
            }
          end
          dap.configurations.lua = {
            {
              type = "nlua",
              request = "attach",
              name = "Attach to running Neovim instance",
            },
          }
        end,
      },
    },

    keys = {
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to line (no execute)",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
    },

    config = function()
      for name, icon in pairs(dap_icons) do
        name = "Dap" .. name
        fn.sign_define(name, {
          text = icon[1],
          texthl = icon[2],
          numhl = icon[2],
        })
      end
    end,
  },
  -- {
  --   "mfussenegger/nvim-dap",
  --   config = function()
  --     local dap = require "dap"
  --     dap.adapters.lldb = {
  --       type = "executable",
  --       command = "/usr/bin/lldb-vscode",
  --       name = "lldb",
  --     }
  --     dap.configurations.cpp = {
  --       {
  --         name = "Launch",
  --         type = "lldb",
  --         request = "launch",
  --         program = function()
  --           return vim.ui.input(
  --             { prompt = "Path to executable:", default = vim.fn.expand "%:t:r" },
  --             function(input)
  --               return input
  --             end
  --           )
  --         end,
  --         cwd = "${workspaceFolder}",
  --         stopOnEntry = false,
  --         args = {},
  --       },
  --     }
  --     dap.configurations.c = dap.configurations.cpp
  --   end,
  -- },
}
