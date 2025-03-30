return {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
        "onsails/lspkind.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "saadparwaiz1/cmp_luasnip",
        {"L3MON4D3/LuaSnip", build = "make install_jsregexp" },
        "amarakon/nvim-cmp-lua-latex-symbols",
    },
    config = function()
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')

        -- change how the menu acts
        vim.opt.completeopt = {"menu", "noselect"}
        vim.opt.shortmess:append "c"

        local lspkind = require("lspkind")
        local luasnip = require("luasnip")
        lspkind.init({})
        local cmp = require("cmp")
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                ["<CR>"] = cmp.mapping(
                    cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }
                ),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

            }),
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end
            },
            sources = {

                { name = 'luasnip' }, -- For luasnip users.
                {name = "nvim_lsp"},
                {name = "path"},
                {name = "buffer"},
            },
            -- filetype = {
            --     { "tex", "plaintex" }, {
            --         sources = {
            --             { name = "lua-latex-symbols"}}
            --     }
            -- }
        })
        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
    end
}
