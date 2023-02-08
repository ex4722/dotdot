local M = {}

local conf = { noremap = true, silent = true }
local recur = { silent = true }


local k = vim.api.nvim_set_keymap


k("", "<Space>", "<Nop>", conf)
vim.g.mapleader = " "
vim.g.maplocalleader = " "



-- Best remap
k("i", "jk", "<ESC>", conf)

-- Use system clipboard
k("", "<C-p>", "<C-r>+", conf)
k("", "Y", "\"+y", conf)

-- Neotree
k("n","<C-e>", ":NeoTreeRevealToggle<CR>", conf)

-- Telly
k("n","<C-x><C-f>", ":Telescope find_files<CR>", conf)
k("n","<leader>pf", ":Telescope find_files<CR>", conf)

-- OrgMode
k("n", "<leader>a", ":lua require('orgmode').action('agenda.prompt')<CR>", conf)
k("n", "<leader>c", ":lua require('orgmode').action('capture.prompt')<CR>", conf)

-- Harpoon
k("n", "H", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", conf)
k("n", "<leader>h", ":lua require('harpoon.mark').add_file()<CR>", conf)

k("n", "<A-1>", ":lua require('harpoon.ui').nav_file(1)<CR>", conf)
k("n", "<A-2>", ":lua require('harpoon.ui').nav_file(2)<CR>", conf)
k("n", "<A-3>", ":lua require('harpoon.ui').nav_file(3)<CR>", conf)

-- Undo Tree 
k("n", "<A-u>", ":UndotreeToggle<CR>", conf)


-- Tmux run program
local buf = vim.api.nvim_get_current_buf() 
local ft = vim.api.nvim_buf_get_option(buf, "filetype")

M.save_and_exec = function()
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    if ft == 'vim' or ft == 'lua' then
        vim.cmd('silent! write')
        vim.cmd('source %')
    elseif ft == 'python' then
        vim.cmd('silent! write')
        vim.cmd("exec '!tmux new-window ipython -i' shellescape(@%, 1)")

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
