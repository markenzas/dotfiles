return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    { "theHamsta/nvim-dap-virtual-text", config = true },
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
  },
  config = function()
    local dap = require("dap")
    local ui = require("dapui")

    dap.set_log_level("TRACE")
    vim.g.dap_virtual_text = true

    require("dapui").setup()

    local exts = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "vue",
    }

    dap.adapters["pwa-chrome"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    for _, ext in ipairs(exts) do
      dap.configurations[ext] = {
        {
          type = "pwa-chrome",
          request = "launch",
          name = 'Launch Chrome with "localhost"',
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost" }, function(url)
                if url == nil or url == "" then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          webRoot = "${workspaceFolder}",
          protocol = "inspector",
          sourceMaps = true,
          userDataDir = false,
          skipFiles = { "<node_internals>/**", "node_modules/**", "${workspaceFolder}/node_modules/**" },
          resolveSourceMapLocations = {
            "${webRoot}/*",
            "${webRoot}/apps/**/**",
            "${workspaceFolder}/apps/**/**",
            "${webRoot}/packages/**/**",
            "${workspaceFolder}/packages/**/**",
            "${workspaceFolder}/*",
            "!**/node_modules/**",
          },
        },
        {
          name = "Next.js: debug server-side (pwa-node)",
          type = "pwa-node",
          request = "attach",
          port = 9231,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File (pwa-node)",
          cwd = vim.fn.getcwd(),
          args = { "${file}" },
          sourceMaps = true,
          protocol = "inspector",
          runtimeExecutable = "pnpm",
          runtimeArgs = {
            "run-script",
            "dev",
          },
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Current File (pwa-node with ts-node)",
          cwd = vim.fn.getcwd(),
          runtimeArgs = { "--loader", "ts-node/esm" },
          runtimeExecutable = "node",
          args = { "${file}" },
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "<node_internals>/**", "node_modules/**" },
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Test Current File (pwa-node with jest)",
          cwd = vim.fn.getcwd(),
          runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
          runtimeExecutable = "node",
          args = { "${file}", "--coverage", "false" },
          rootPath = "${workspaceFolder}",
          sourceMaps = true,
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
          skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Test Current File (pwa-node with vitest)",
          cwd = vim.fn.getcwd(),
          program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
          args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
          autoAttachChildProcesses = true,
          smartStep = true,
          console = "integratedTerminal",
          skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Test Current File (pwa-node with deno)",
          cwd = vim.fn.getcwd(),
          runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
          runtimeExecutable = "deno",
          attachSimplePort = 9229,
        },
        {
          type = "pwa-chrome",
          request = "attach",
          name = "Attach Program (pwa-chrome, select port)",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          port = function()
            return vim.fn.input("Select port: ", 9222)
          end,
          webRoot = "${workspaceFolder}",
          skipFiles = { "<node_internals>/**", "node_modules/**", "${workspaceFolder}/node_modules/**" },
          resolveSourceMapLocations = {
            "${webRoot}/*",
            "${webRoot}/apps/**/**",
            "${workspaceFolder}/apps/**/**",
            "${webRoot}/packages/**/**",
            "${workspaceFolder}/packages/**/**",
            "${workspaceFolder}/*",
            "!**/node_modules/**",
          },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach Program (pwa-node, select pid)",
          cwd = vim.fn.getcwd(),
          processId = require("dap.utils").pick_process,
          skipFiles = { "<node_internals>/**" },
        },
      }
    end

    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = { "/home/markas/projects/dap/vscode-php-debug/out/phpDebug.js" },
    }

    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
      },
    }

    dap.adapters.godot = {
      {
        type = "server",
        host = "127.0.0.1",
        port = "6006",
      },
    }

    dap.configurations.gdscript = {
      {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
      },
    }

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<leader>dr", dap.run_to_cursor)

    vim.keymap.set("n", "<F1>", dap.continue, { silent = true })
    vim.keymap.set("n", "<F2>", dap.step_into)
    vim.keymap.set("n", "<F3>", dap.step_over)
    vim.keymap.set("n", "<F4>", dap.step_out)
    vim.keymap.set("n", "<F5>", dap.step_back)
    vim.keymap.set("n", "<F9>", dap.restart)
    vim.keymap.set("n", "<F10>", ui.close)

    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end

    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end

    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end

    dap.listeners.before.event_exited.dapui_config = function()
      ui.open()
    end
  end,
}
