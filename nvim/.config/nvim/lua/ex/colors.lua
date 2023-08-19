vim.cmd "set background=dark"
vim.cmd "colorscheme solarized8"

-- Tmux shit
vim.cmd ([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
vim.cmd ([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])

vim.cmd ([[set t_Co=256]])
