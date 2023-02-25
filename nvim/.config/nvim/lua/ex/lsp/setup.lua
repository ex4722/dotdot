local lsp = require "lspconfig"
local coq = require "coq" -- add this

local on_attach = require("ex.lsp.lsp").on_attach

require("lspconfig").pyright.setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach
}))
require("lspconfig").clangd.setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach
}))
require("lspconfig").tsserver.setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach
}))

-- require("lspconfig").arduino_language_server.setup(coq.lsp_ensure_capabilities({
--     on_attach = on_attach,
--         cmd = {
--         "arduino-language-server",
--         "-cli-config", "/home/ex/.arduino15/arduino-cli.yaml",
--         "-fqbn", "arduino:uvr:uno",
--         "-cli", "/home/ex/.local/bin/arduino-cli",
--         "-clangd", "/bin/clangd"
--     }
-- }))


require('arduino').setup({
    default_fqbn = "arduino:avr:uno",

    --Path to clangd (all paths must be full)
    clangd = "/bin/clangd",

    --Path to arduino-cli
    arduino = "/home/ex/.local/bin/arduino-cli",

    --Data directory of arduino-cli
    arduino_config_dir ="/home/ex/.arduino15/arduino-cli.yaml",

    --Extra options to arduino-language-server
})

require 'lspconfig' ['arduino_language_server'].setup {
    on_new_config = require('arduino').on_new_config,
}
