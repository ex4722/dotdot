return {
    "neovim/nvim-lspconfig",
    config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

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
                map('gi', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, 'Toggle Inlay')

                vim.keymap.set('i', "<C-l>", vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'LSP: signature_help' })
            end,
        })
        vim.lsp.config.clangd = {
            cmd = {'clangd'},
            root_markers = { 'compile_commands.json', 'compile_flags.txt' },
            filetypes = { 'c', 'cpp' },
        }
        vim.lsp.config.python = {
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
            single_file_support = true,
        }

        vim.lsp.config.racket_langserver= {
            cmd = { 'racket', '--lib', 'racket-langserver' },
            filetypes = { 'racket', 'scheme' },
            -- root_dir = function(fname)
            --     return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            -- end,
            single_file_support = true,
        }

        vim.lsp.config.omnisharp= {
            cmd = {
                "/Users/ex/Downloads/omnisharp-osx-arm64-net6.0/OmniSharp",
                "--languageserver",
                "--hostPID",
                tostring(vim.fn.getpid()),
            },

            cmd_env = {
                DOTNET_ROOT = "/usr/local/share/dotnet/"
            },
            filetypes = { "cs" },
            root_markers = { "*.sln", "*.csproj", ".git" },
        }

        vim.lsp.enable('python')
        vim.lsp.enable('clangd')
        vim.lsp.enable('omnisharp')
        vim.lsp.enable('racket_langserver')
        vim.lsp.enable('gopls')


    end
}

