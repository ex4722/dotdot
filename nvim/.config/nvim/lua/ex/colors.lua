vim.cmd "set background=dark"
vim.cmd "colorscheme solarized8"


vim.cmd ([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
vim.cmd ([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])

vim.cmd ([[set t_Co=256]])
-- vim.cmd("highlight LineNr guibg=NONE")

vim.cmd('hi LspSagaFinderSelection guifg=#d33682')
vim.cmd('hi FloatBorder guifg=#b3deef')
vim.cmd('hi NormalFloat guibg=#002b36 guifg=#268bd2')
vim.cmd('highlight VertSplit guibg=#002b36')
