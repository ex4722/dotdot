return {
    "lifepillar/vim-solarized8",
    config = function()
        vim.opt.background="dark"
        vim.cmd("colorscheme solarized8")

        -- Tmux shit
        vim.cmd ([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
        vim.cmd ([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
        vim.cmd ([[set t_Co=256]])
        vim.cmd("hi VertSplit ctermfg=236 ctermbg=242 guifg=#268bd2 guibg=#002b36")
        vim.cmd("hi NormalFloat guibg=#073642")

        -- Git Gutter Signs
        vim.cmd("highlight SignColumn guibg=NONE")
        vim.cmd("highlight DiffAdd guifg=#859900 guibg=NONE")
        vim.cmd("highlight DiffChange guifg=#b58900 guibg=NONE")
        vim.cmd("highlight DiffDelete gui=bold guifg=#dc322f guibg=NONE")
end
}
