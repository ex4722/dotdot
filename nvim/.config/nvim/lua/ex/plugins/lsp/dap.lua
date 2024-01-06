local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
}
return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "mfussenegger/nvim-dap-python",
        "Pocco81/DAPInstall.nvim",
        "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()
        require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
        require("nvim-dap-virtual-text").setup()
        local keymap = vim.keymap
        keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>")
        keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>")
        keymap.set("n", "<leader>dfi", "<cmd>DapStepOut<CR>")
        keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>")
        keymap.set("n", "<leader>do", "<cmd>DapStepOver<CR>")
        keymap.set(
            "n",
            "<leader>duf",
            "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>"
        )
        -- dap.configurations.javascript = {
        --     {
        --         type = "node2",
        --         request = "launch",
        --         program = "${workspaceFolder}/${file}",
        --         cwd = vim.fn.getcwd(),
        --         sourceMaps = true,
        --         protocol = "inspector",
        --         console = "integratedTerminal",
        --     },
        -- }
        --
        -- local custom_adapter = "pwa-node-custom"
        -- dap.adapters[custom_adapter] = function(cb, config)
        --     if config.preLaunchTask then
        --         local async = require("plenary.async")
        --         local notify = require("notify").async
        --
        --         async.run(function()
        --             ---@diagnostic disable-next-line: missing-parameter
        --             notify("Running [" .. config.preLaunchTask .. "]").events.close()
        --         end, function()
        --             vim.fn.system(config.preLaunchTask)
        --             config.type = "pwa-node"
        --             dap.run(config)
        --         end)
        --     end
        -- end
        --
        -- -- language config
        -- for _, language in ipairs({ "typescriptreact", "javascript" }) do
        --     dap.configurations[language] = {
        --         {
        --             name = "Launch",
        --             type = "pwa-node",
        --             request = "launch",
        --             program = "${file}",
        --             rootPath = "${workspaceFolder}",
        --             cwd = "${workspaceFolder}",
        --             sourceMaps = true,
        --             skipFiles = { "<node_internals>/**" },
        --             protocol = "inspector",
        --             console = "integratedTerminal",
        --         },
        --         {
        --             name = "Attach to node process",
        --             type = "pwa-node",
        --             request = "attach",
        --             rootPath = "${workspaceFolder}",
        --             processId = require("dap.utils").pick_process,
        --         },
        --         {
        --             name = "Debug Main Process (Electron)",
        --             type = "pwa-node",
        --             request = "launch",
        --             program = "${workspaceFolder}/node_modules/.bin/electron",
        --             args = {
        --                 "${workspaceFolder}/dist/index.js",
        --             },
        --             outFiles = {
        --                 "${workspaceFolder}/dist/*.js",
        --             },
        --             resolveSourceMapLocations = {
        --                 "${workspaceFolder}/dist/**/*.js",
        --                 "${workspaceFolder}/dist/*.js",
        --             },
        --             rootPath = "${workspaceFolder}",
        --             cwd = "${workspaceFolder}",
        --             sourceMaps = true,
        --             skipFiles = { "<node_internals>/**" },
        --             protocol = "inspector",
        --             console = "integratedTerminal",
        --         },
        --         {
        --             name = "Compile & Debug Main Process (Electron)",
        --             type = custom_adapter,
        --             request = "launch",
        --             preLaunchTask = "npm run build-ts",
        --             program = "${workspaceFolder}/node_modules/.bin/electron",
        --             args = {
        --                 "${workspaceFolder}/dist/index.js",
        --             },
        --             outFiles = {
        --                 "${workspaceFolder}/dist/*.js",
        --             },
        --             resolveSourceMapLocations = {
        --                 "${workspaceFolder}/dist/**/*.js",
        --                 "${workspaceFolder}/dist/*.js",
        --             },
        --             rootPath = "${workspaceFolder}",
        --             cwd = "${workspaceFolder}",
        --             sourceMaps = true,
        --             skipFiles = { "<node_internals>/**" },
        --             protocol = "inspector",
        --             console = "integratedTerminal",
        --         },
        --     }
        -- end

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end,
}
-- local js_based_languages = {
--   "typescript",
--   "javascript",
--   "typescriptreact",
--   "javascriptreact",
--   "vue",
-- }
--
-- return {
--   {
--     "mfussenegger/nvim-dap",
--     config = function()
--       local dap = require("dap")
--
--
--       for _, language in ipairs(js_based_languages) do
--         dap.configurations[language] = {
--           -- Debug single nodejs files
--           {
--             type = "pwa-node",
--             request = "launch",
--             name = "Launch file",
--             program = "${file}",
--             cwd = vim.fn.getcwd(),
--             sourceMaps = true,
--           },
--           -- Debug nodejs processes (make sure to add --inspect when you run the process)
--           {
--             type = "pwa-node",
--             request = "attach",
--             name = "Attach",
--             processId = require("dap.utils").pick_process,
--             cwd = vim.fn.getcwd(),
--             sourceMaps = true,
--           },
--           -- Debug web applications (client side)
--           {
--             type = "pwa-chrome",
--             request = "launch",
--             name = "Launch & Debug Chrome",
--             url = function()
--               local co = coroutine.running()
--               return coroutine.create(function()
--                 vim.ui.input({
--                   prompt = "Enter URL: ",
--                   default = "http://localhost:3000",
--                 }, function(url)
--                   if url == nil or url == "" then
--                     return
--                   else
--                     coroutine.resume(co, url)
--                   end
--                 end)
--               end)
--             end,
--             webRoot = vim.fn.getcwd(),
--             protocol = "inspector",
--             sourceMaps = true,
--             userDataDir = false,
--           },
--           -- Divider for the launch.json derived configs
--           {
--             name = "----- ↓ launch.json configs ↓ -----",
--             type = "",
--             request = "launch",
--           },
--         }
--       end
--     end,
--     keys = {
--       {
--         "<leader>dO",
--         function()
--           require("dap").step_out()
--         end,
--         desc = "Step Out",
--       },
--       {
--         "<leader>do",
--         function()
--           require("dap").step_over()
--         end,
--         desc = "Step Over",
--       },
--       {
--         "<leader>da",
--         function()
--           if vim.fn.filereadable(".vscode/launch.json") then
--             local dap_vscode = require("dap.ext.vscode")
--             dap_vscode.load_launchjs(nil, {
--               ["pwa-node"] = js_based_languages,
--               ["chrome"] = js_based_languages,
--               ["pwa-chrome"] = js_based_languages,
--             })
--           end
--           require("dap").continue()
--         end,
--         desc = "Run with Args",
--       },
--     },
--     dependencies = {
--       -- Install the vscode-js-debug adapter
--       {
--         "microsoft/vscode-js-debug",
--         -- After install, build it and rename the dist directory to out
--         build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
--         version = "1.*",
--       },
--       {
--         "mxsdev/nvim-dap-vscode-js",
--         config = function()
--           ---@diagnostic disable-next-line: missing-fields
--           require("dap-vscode-js").setup({
--             -- Path of node executable. Defaults to $NODE_PATH, and then "node"
--             -- node_path = "node",
--
--             -- Path to vscode-js-debug installation.
--             debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
--
--             -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
--             -- debugger_cmd = { "js-debug-adapter" },
--
--             -- which adapters to register in nvim-dap
--             adapters = {
--               "chrome",
--               "pwa-node",
--               "pwa-chrome",
--               "pwa-msedge",
--               "pwa-extensionHost",
--               "node-terminal",
--             },
--
--             -- Path for file logging
--             -- log_file_path = "(stdpath cache)/dap_vscode_js.log",
--
--             -- Logging level for output to file. Set to false to disable logging.
--             -- log_file_level = false,
--
--             -- Logging level for output to console. Set to false to disable console output.
--             -- log_console_level = vim.log.levels.ERROR,
--           })
--         end,
--       },
--       {
--         "Joakker/lua-json5",
--         build = "./install.sh",
--       },
--     },
--   },
-- }
