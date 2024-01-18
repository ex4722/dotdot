return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
        })

        vim.diagnostic.config({
            virtual_text = false,
        })
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local keymap = vim.keymap.set
        local capabilities = cmp_nvim_lsp.default_capabilities()
        capabilities.offsetEncoding = { "utf-16" }

        local on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint(bufnr, true)
            end
            -- require("clangd_extensions.inlay_hints").setup_autocmd()
            -- require("clangd_extensions.inlay_hints").set_inlay_hints()
        end

        lspconfig.pyright.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
        lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            on_attach = on_attach,
        })
        -- lspconfig.ltex.setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        -- })

        -- lspconfig.lua_ls.setup({
        --     capabilities = capabilities,
        --     on_attach = on_attach,
        --     settings = { -- custom settings for lua
        --         Lua = {
        --             -- make the language server recognize "vim" global
        --             diagnostics = {
        --                 globals = { "vim" },
        --             },
        --             workspace = {
        --                 -- make language server aware of runtime files
        --                 library = {
        --                     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        --                     [vim.fn.stdpath("config") .. "/lua"] = true,
        --                 },
        --             },
        --         },
        --     },
        -- })
        --

        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            on_init = function(client)
                client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = "LuaJIT",
                        },

                        diagnostics = {
                            globals = { "vim", "use", "winid" },
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.stdpath("config") .. "/lua"] = true,
                                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                            },
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        },
                    },
                })

                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                return true
            end,
        })
        lspconfig.clangd.setup({
            capabilities = capabilities,
            on_attach = on_attach;
            -- on_attach = function(client, bufrn)
            --     require("clangd_extensions.inlay_hints").setup_autocmd()
            --     require("clangd_extensions.inlay_hints").set_inlay_hints()
            -- end,
            cmd = { "clangd", "--inlay-hints=true" },
        })

        lspconfig.tsserver.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                javascript = {
                    inlayHints = {
                        includeInlayEnumMemberValueHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayParameterNameHints = "all",
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
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    },
                },
            },
        })

        -- leave here or LSP On_attach?
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

                -- Buffer local mappings.
                local opts = { buffer = ev.buf }
                keymap("n", "gD", vim.lsp.buf.declaration, opts)
                keymap("n", "gd", vim.lsp.buf.definition, opts)
                keymap("n", "K", vim.lsp.buf.hover, opts)
                keymap("n", "gi", vim.lsp.buf.implementation, opts)
                keymap("n", "gl", vim.diagnostic.open_float, opts)
                keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
                keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
                keymap("n", "<space>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                keymap("n", "<space>D", vim.lsp.buf.type_definition, opts)
                keymap("n", "gr", vim.lsp.buf.rename, opts)
                keymap({ "n", "v" }, "ga", vim.lsp.buf.code_action, opts)
                keymap("n", "<space>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
                keymap("n", "<leader>H", function()
                    vim.lsp.inlay_hint(0, nil)
                end, opts)

                keymap("n", "gf", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
            end,
        })
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end
        local diagnostics_active = true

        local toggle_diagnostics = function()
            diagnostics_active = not diagnostics_active
            if diagnostics_active then
                vim.diagnostic.config({ virtual_text = false })
            else
                vim.diagnostic.config({ virtual_text = true })
            end
        end

        vim.keymap.set("n", "<leader>dt", toggle_diagnostics)
    end,
}
