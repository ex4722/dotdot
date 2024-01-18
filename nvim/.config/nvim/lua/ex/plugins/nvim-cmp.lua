return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",     -- source for text in buffer
        "hrsh7th/cmp-path",       -- source for file system paths
        "L3MON4D3/LuaSnip",       -- snippet engine
        "saadparwaiz1/cmp_luasnip", -- for autocompletion
        "rafamadriz/friendly-snippets", -- useful snippets
        "onsails/lspkind.nvim",   -- vs-code like pictograms
    },
    config = function()
        local cmp = require("cmp")

        local luasnip = require("luasnip")
        require("luasnip").config.set_config({ -- Setting LuaSnip config

            -- Enable autotriggered snippets
            enable_autosnippets = true,
        })

        local lspkind = require("lspkind")

        -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
        require("luasnip.loaders.from_vscode").lazy_load()

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
        cmp.setup({
            -- completion = {
            --       completeopt = "menu,menuone,preview,noselect",
            --     },
            completion = {
                -- autocomplete = true,
                keyword_length = 2,
            },
            snippet = { -- configure how nvim-cmp interacts with snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if #cmp.get_entries() == 1 then
                            cmp.confirm({ select = true })
                        else
                            cmp.select_next_item()
                        end
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                        if #cmp.get_entries() == 1 then
                            cmp.confirm({ select = true })
                        end
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            -- sources for autocompletion
            sources = cmp.config.sources({
                { name = "path" }, -- file system paths
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- snippets
                -- { name = "buffer" }, -- text within current buffer
            }),
            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.recently_used,
                    require("clangd_extensions.cmp_scores"),
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
            -- configure lspkind for vs-code like pictograms in completion menu
            formatting = {
                format = lspkind.cmp_format({
                    maxwidth = 50,
                    ellipsis_char = "...",
                }),
            },
        })
        cmp.setup.filetype("tex", {
            formatting = {
                -- nvim-cmp overrides the standard completion-menu formatting. We use
                -- a custom format function to preserve the format as provided by
                -- VimTeX's omni completion function:
                format = function(entry, vim_item)
                    vim_item.menu = ({
                        omni = (vim.inspect(vim_item.menu):gsub('%"', "")),
                        buffer = "[Buffer]",
                        -- formatting for other sources
                    })[entry.source.name]
                    return vim_item
                end,
            },
            sources = {
                { name = "luasnip" }, -- snippets
                { name = "vimtex" },
                { name = "omni",  trigger_characters = { "{", "\\" } },
                -- { name = "buffer" },
                -- other sources
            },
        })
    end,
}
