function get_undodir()
    -- on macbook
    if vim.fn.has("macunix") == 1 then
        return "/User/cxiaoedd/.config/nvim/undodir"
    -- dev desktop
    elseif string.find(vim.fn.hostname(), "dev-dsk") then
        return "/home/cxiaoedd/.config/nvim/undodir"
    -- laptops
    else
        return "/home/ex/.config/nvim/undodir"
    end
end


local options = {
   -- Displaying Columns
   number = true,
   relativenumber = true,

   -- Scrolling horizontal and diag
   scrolloff = 20,
   sidescrolloff= 15,

   -- Shifting convert to space
   expandtab = true,
   shiftround = true,
   shiftwidth = 4,
   tabstop = 4,
   softtabstop = 4,

   -- Quality of Life
   wrap = false,
   visualbell = false,
   hidden = true,

   -- Themeing stuff
   termguicolors = true,

   -- Save undo to file
   swapfile = false,
   undofile = true,
   undodir = get_undodir(),

   -- Searching 
   ignorecase = true,
   smartcase = true,
   incsearch = true,

   -- Display 
   signcolumn = "yes",
   showtabline=1,
   cmdheight=0,

   -- Mouse
   guicursor = '',
   mouse = 'c',
}

for opt, value in pairs(options) do
    vim.opt[opt] = value
end

-- Flash when yank
vim.api.nvim_create_autocmd({"TextYankPost"}, {
    pattern = {"*"},
    callback = function() vim.highlight.on_yank() end,
})
