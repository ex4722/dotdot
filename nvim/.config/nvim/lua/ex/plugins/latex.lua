-- latex shit
-- setlocal spell
-- set spelllang=nl,en_gb
-- inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

return {
    "lervag/vimtex",
    -- dependencies = {
    --     "evesdropper/luasnip-latex-snippets.nvim",
    -- },
    config = function()
        vim.g.vimtex_view_method = "zathura"
        vim.o.foldmethod = "expr"
        vim.o.foldexpr="vimtex#fold#level(v:lnum)"
        vim.o.foldtext="vimtex#fold#text()"
        -- I like to see at least the content of the sections upon opening
        vim.o.foldlevel=2
    end
}
