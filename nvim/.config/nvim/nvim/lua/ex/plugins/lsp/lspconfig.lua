return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap.set
        local capabilities = cmp_nvim_lsp.default_capabilities()
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            border = "single",
            }
        )

        on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.buf.inlay_hint(bufnr, true)
            end
        end

        lspconfig.pyright.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })

        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = { -- custom settings for lua
            Lua = {
                -- make the language server recognize "vim" global
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    -- make language server aware of runtime files
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true
                    },
                },
            },
        }
    })

    lspconfig.tsserver.setup({
        capabilities = capabilities,
        settings = {
            javascript = {
                inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
            },
            typescript = {
                inlayHints = {
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
            },
        },
    })



    -- leave here or LSP On_attach?
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            local opts = { buffer = ev.buf }
            keymap('n', 'gD', vim.lsp.buf.declaration, opts)
            keymap('n', 'gd', vim.lsp.buf.definition, opts)
            keymap('n', 'K', vim.lsp.buf.hover, opts)
            keymap('n', 'gi', vim.lsp.buf.implementation, opts)
            keymap('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            keymap('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            keymap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            keymap('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            keymap('n', '<space>D', vim.lsp.buf.type_definition, opts)
            keymap('n', 'gr', vim.lsp.buf.rename, opts)
            keymap({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
            keymap('n', '<space>f', function()
                vim.lsp.buf.format { async = true }
            end, opts)
            keymap('n', '<leader>H', function() vim.lsp.inlay_hint(0, nil) end, opts )

            keymap('n', 'gf', "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        end,
    })
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end,
}
