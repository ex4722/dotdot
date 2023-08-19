local M = {}

local conf = { noremap = true, silent = true }
local recur = { silent = true }


local k = vim.api.nvim_set_keymap


k("", "<Space>", "<Nop>", conf)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Moving text around in visual mode
k("v", "J", ":m '>+1<CR>gv=gv", conf)
k("v", "K", ":m '<-2<CR>gv=gv", conf)
k("v", "<", "<gv", conf)
k("v", ">", ">gv", conf)

k("x", "J", ":m '>+1<CR>gv=gv", conf)
k("x", "K", ":m '<-2<CR>gv=gv", conf)
k("x", "<", "<gv", conf)
k("x", ">", ">gv", conf)

-- Best remap
k("i", "jk", "<ESC>", conf)

-- Use system clipboard
k("", "<C-p>", "<C-r>+", conf)
k("", "Y", "\"+y", conf)


vim.keymap.set('n', '<A-u>', vim.cmd.UndotreeToggle)
vim.keymap.set('n', '<leader>gg', require('neogit').open)

vim.keymap.set('n', '<C-x><C-s>', ":w<cr>")

-- harpoon 
vim.keymap.set('n', 'Ha', ":lua require('harpoon.mark').add_file()<CR>")
vim.keymap.set('n', 'H', ":lua require('harpoon.ui').toggle_quick_menu()<CR>")

vim.keymap.set('n', '<leader>a', ":lua require('harpoon.ui').nav_file(1)<CR>")
vim.keymap.set('n', '<leader>s', ":lua require('harpoon.ui').nav_file(2)<CR>")
vim.keymap.set('n', '<leader>d', ":lua require('harpoon.ui').nav_file(3)<CR>")
vim.keymap.set('n', '<leader>f', ":lua require('harpoon.ui').nav_file(4)<CR>")




-- Telly 
vim.keymap.set('n', '<leader>pf', ":Telescope find_files<CR>")
vim.keymap.set('n', '<leader>pr', ":Telescope live_grep<CR>")

M.save_and_exec = function()
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    if ft == 'vim' or ft == 'lua' then
        vim.cmd('silent! write')
        vim.cmd('source %')
    elseif ft == 'python' then
        vim.cmd('silent! write')
        vim.cmd("exec 'silent !tmux new-window ipython -i' shellescape(@%, 1)")

    elseif ft == 'c' then
        vim.cmd('silent! write')
        vim.cmd('sp')
        local file = vim.fn.expand('%')
        local output = vim.fn.expand('%:t:r')
        local command = 'gcc %s -o %s && ./%s; rm %s'
        M.run_term(command, file, output, output, output)
    elseif ft == 'http' then
        -- Not really save and exec, but think it fits nicely in here for mapping
        require('rest-nvim').run()
    end
end

k("n" , "<C-b>", ":lua require('ex.keymaps').save_and_exec()<CR>", conf)

return M
