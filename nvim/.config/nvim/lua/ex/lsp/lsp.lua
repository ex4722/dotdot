local M = {}
local lsp = require "lspconfig"
local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "", guibg="#073642"  })
end

local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
        active = signs,
    },

    update_in_insert = true,
    underline = true,
    severity_sort = true,

    float = {
        focusable = false,
        style = "minimal",
        -- border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
}

vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})


require("ex.lsp.saga")
require("ex.lsp.coq")

local function lsp_highlight_document(client)
    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
        vim.api.nvim_exec(
        [[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]],
        false
        )
    end
end

M.on_attach = function(client, bufnr)
    require'virtualtypes'.on_attach()
    require "lsp_signature".on_attach({
        hi_parameter = "LspSagaFinderSelection",
        hint_enable = false,
        floating_window_off_x = -10,
        bind = true,
        handler_opts = {
            border = "rounded"
        }
    }, bufnr)
    --    lsp_highlight_document(client)

    local k = vim.api.nvim_buf_set_keymap
    local opts = { noremap = true, silent = true }

    -- Keymaps Here
    k(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    k(bufnr, 'n', 'gd', ':Lspsaga peek_definition<CR>', opts)
    k(bufnr, 'n', 'ga', ':Lspsaga code_action<CR>', opts)
    k(bufnr, 'n', '<C-k>', ':Lspsaga hover_doc<CR>', opts)
    k(bufnr, 'n', 'K', ":lua vim.lsp.buf.signature_help()<CR>", opts)
    k(bufnr, 'n', 'gr', '<cmd>Lspsaga rename<cr>', opts)
    k(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
    k(bufnr, 'n', 'gl', "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>", opts)
    k(bufnr, 'n', 'gh', '<Cmd>Lspsaga lsp_finder<CR>', opts)



end

return M
