local on_attach = require("ex.lsp.lsp").on_attach

require('lspconfig')['pyright'].setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach,
    flags = lsp_flags,
}))

require('lspconfig')['clangd'].setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach,
    flags = lsp_flags,
}))


require('lspconfig')['tsserver'].setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach,
    flags = lsp_flags,
}))
