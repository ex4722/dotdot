return {
    "lervag/vimtex",

    dependencies = {
        "micangl/cmp-vimtex",
        "hrsh7th/cmp-omni",
        "iurimateus/luasnip-latex-snippets.nvim",
    },
    config = function()
        -- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
        -- require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/tex/test.lua" })
        -- require'luasnip-latex-snippets'.setup({use_treesitter = false, enable_autosnippets = true})

        vim.g["vimtex_view_method"] = "zathura"

        -- Ignore mappings
        vim.g["vimtex_mappings_enabled"] = 0

        -- Auto Indent
        vim.g["vimtex_indent_enabled"] = 0

        -- Syntax highlighting
        vim.g["vimtex_syntax_enabled"] = 1

        -- Compiler
        vim.g["vimtex_compiler_method "] = "latexmk"
        require("cmp_vimtex").setup({
            additional_information = {
                info_in_menu = true,
                info_in_window = true,
                info_max_length = 60,
                match_against_info = true,
                symbols_in_menu = true,
            },
            bibtex_parser = {
                enabled = true,
            },
        })

    local keymap = vim.keymap
    keymap.set("n", "<leader>ll", "<Cmd>VimtexCompile<CR>", {desc = "Vimtex Compile"})
    keymap.set("n", "<leader>lj", "<Cmd>VimtexView<CR>", {desc = "Vimtex Jump to Section"})
    end,
}
