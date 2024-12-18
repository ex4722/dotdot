return {
    "neovim/nvim-lspconfig",
    config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

                -- Find references for the word under your cursor.
                -- map('gf', vim.lsp.buf.references, '[G]oto [R]eferences')
                map('gf', require('fzf-lua').lsp_references, '[G]oto [R]erences')

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map('gI', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

                -- Lists the current diagnostics on this line
                map('gl', vim.diagnostic.open_float, '[L]ist diagnostics')

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                -- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map('gs', require('fzf-lua').lsp_live_workspace_symbols, '[G]oto Workspace [S]ymbols')

                -- Auto format shit
                map('<leader>f', vim.lsp.buf.format, '[F]format')

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map('gr', vim.lsp.buf.rename, '[R]ename')

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map('gc', vim.lsp.buf.code_action, '[C]ode [A]ction')

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                map('ga', vim.lsp.buf.code_action, '[G]oto [A]ctions')

                map('K', vim.lsp.buf.hover , 'Hover')

                map('<C-l>', vim.lsp.buf.signature_help, 'signature_help')
                vim.keymap.set('i', "<C-l>", vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'LSP: signature_help' })

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                -- local client = vim.lsp.get_client_by_id(event.data.client_id)
                -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                --   local highlight_augroup = vim.api.nvim_create_augroup('ex-lsp-highlight', { clear = false })
                --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                --     buffer = event.buf,
                --     group = highlight_augroup,
                --     callback = vim.lsp.buf.document_highlight,
                --   })
                --
                --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                --     buffer = event.buf,
                --     group = highlight_augroup,
                --     callback = vim.lsp.buf.clear_references,
                --   })
                --
                --   vim.api.nvim_create_autocmd('LspDetach', {
                --     group = vim.api.nvim_create_augroup('ex-lsp-detach', { clear = true }),
                --     callback = function(event2)
                --       vim.lsp.buf.clear_references()
                --       vim.api.nvim_clear_autocmds { group = 'ex-lsp-highlight', buffer = event2.buf }
                --     end,
                --   })
                -- end

                -- The following code creates a keymap to toggle inlay hints in your
                -- code, if the language server you are using supports them
                -- This may be unwanted, since they displace some of your code
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    map('ghh', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, '[T]oggle Inlay [H]ints')
                end
            end,

            vim.diagnostic.config({
                virtual_text = false,
            })
        })

        -- vim.api.nvim_create_user_command("LspCapabilities", function()
        -- 	local curBuf = vim.api.nvim_get_current_buf()
        -- 	local clients = vim.lsp.get_active_clients { bufnr = curBuf }
        --
        -- 	for _, client in pairs(clients) do
        -- 		if client.name ~= "null-ls" then
        -- 			local capAsList = {}
        -- 			for key, value in pairs(client.server_capabilities) do
        -- 				if value and key:find("Provider") then
        -- 					local capability = key:gsub("Provider$", "")
        -- 					table.insert(capAsList, "- " .. capability)
        -- 				end
        -- 			end
        -- 			table.sort(capAsList) -- sorts alphabetically
        -- 			local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
        -- 			vim.notify(msg, "trace", {
        -- 				on_open = function(win)
        -- 					local buf = vim.api.nvim_win_get_buf(win)
        -- 					vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
        -- 				end,
        -- 				timeout = 14000,
        -- 			})
        -- 			fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
        -- 		end
        -- 	end
        -- end, {})

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        require'lspconfig'.pyright.setup{}
        require'lspconfig'.clangd.setup{
            settings = {
                clangd = {
                    InlayHints = {
                        Designators = true,
                        Enabled = true,
                        ParameterNames = true,
                        DeducedTypes = true,
                    },
                    fallbackFlags = { "-std=c++20" },
                },
            }


        }
        require'lspconfig'.texlab.setup{}
        require'lspconfig'.ts_ls.setup{}
        require'lspconfig'.asm_lsp.setup{}
        require'lspconfig'.rust_analyzer.setup{}

    end
}
