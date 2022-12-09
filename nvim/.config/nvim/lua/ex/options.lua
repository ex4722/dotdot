local options = {
   scrolloff = 20,
   smartindent = true,
   number = true,
   relativenumber = true,
   shiftround = true,
   shiftwidth = 4,
   softtabstop = 4,
   linebreak = true,
   sidescrolloff= 15,
   wrap = false,
   visualbell = false,
   termguicolors = true,
   hidden = true,
   swapfile = false,


   undofile = true,
   undodir = "/home/ex/.config/nvim/undodir",
   signcolumn = "yes",
   ignorecase = true,
   smartcase = true,
   incsearch = true,
   expandtab = true,
   guicursor = '',
   mouse = 'c',
   cmdheight=1,

}
for opt, value in pairs(options) do
    vim.opt[opt] = value
end

vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank()")
vim.wo.fillchars='eob: '
