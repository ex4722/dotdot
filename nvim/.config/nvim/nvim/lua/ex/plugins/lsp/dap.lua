return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "mfussenegger/nvim-dap-python",
    },
    config = function()
        dapui = require("dapui")
        dapui.setup()
        require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
        require("nvim-dap-virtual-text").setup()
        local keymap = vim.keymap
        keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>")
        keymap.set("n", "<leader>dc", "<cmd>DapContinue<CR>")
        keymap.set("n", "<leader>dfi", "<cmd>DapStepOut<CR>")
        keymap.set("n", "<leader>di", "<cmd>DapStepInto<CR>")
        keymap.set("n", "<leader>do", "<cmd>DapStepOver<CR>")

        local dap, dapui = require("dap"), require("dapui")
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
