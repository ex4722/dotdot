local conf = { noremap = true, silent = true }
local recur = { silent = true }

local k = vim.api.nvim_set_keymap

-- Leader key stuff
k("", "<Space>", "<Nop>", conf)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

k("n", ",<cr>", ":noh<cr>", conf)
k("n", ",q", ":q!<cr>", conf)
k("n", ",x", ":x<cr>", conf)

-- Cursor Location during finds 
k("n", "n", "nzzzv", conf)
k("n", "N", "Nzzzv", conf)
k("n", "J", "mzJ`z", conf)

-- BEST REMAP 
k("i", "jk", "<ESC>", conf)

k("n", "ac", "ggVG", conf)

-- System clipboard
k("", "<C-p>", "<C-r>+", conf)
k("", "Y", "\"+y", conf)


-- Moving text around in visual mode
k("v", "J", ":m '>+1<CR>gv=gv", conf)
k("v", "K", ":m '<-2<CR>gv=gv", conf)
k("v", "<", "<gv", conf)
k("v", ">", ">gv", conf)

k("x", "J", ":m '>+1<CR>gv=gv", conf)
k("x", "K", ":m '<-2<CR>gv=gv", conf)
k("x", "<", "<gv", conf)
k("x", ">", ">gv", conf)


-- Tabs and Crap 
k("n","<leader><tab>",":tabNext<CR>", conf)
k("n", "<tab>", ":TablineBufferNext<CR>", conf)
k("n", "<S-tab>", ":tabnex<CR>", conf)


-- Spectre_panel
k("n", "<c-f>", ":lua require('spectre').open_visual({select_word=true})<CR>", conf)



-- RIP TELLY FZF
k("n", ";f", "<cmd>Files<CR>", conf)
k("n", "gf", "<cmd>References<CRj", conf)
k("n", ";r", "<cmd>Rg<cr>", conf)


-- Telly 
-- k("n", ";r", "<cmd>Telescope live_grep<cr>", conf)
-- k("n", "\\\\", "<cmd>Telescope buffers<cr>", conf)
-- k("n", ";;", "<cmd>Telescope help_tags<cr>", conf)
-- k("n", "gf", "<cmd>Telescope lsp_references<cr>", conf)
-- 
-- 
-- Undo Tree 
k("n", "<A-u>", ":UndotreeToggle<CR>", conf)


k("n" , "<C-b>", ":w<CR>:exec '!tmux new-window ipython -i' shellescape(@%, 1)<CR>-", conf)


-- NvimTreeee
k("n", "<C-e>", ":NvimTreeToggle<CR>", conf)
-- 
-- -- HARPOOOON
-- k("n", "H", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", conf)
-- k("n", "<space>a", ":lua require('harpoon.mark').add_file()<CR>", conf)
-- k("n", "<space>f", ":lua require('harpoon.ui').nav_file(1)<CR>", conf)
-- k("n", "<space>d", ":lua require('harpoon.ui').nav_file(2)<CR>", conf)
-- k("n", "<space>s", ":lua require('harpoon.ui').nav_file(3)<CR>", conf)
-- 
-- 
-- 
-- -- DAP
-- k("n", "<F5>", ":lua require'dap'.continue()<CR>", conf)
-- k("n", "<F1>", ":lua require'dap'.step_into()<CR>", conf)
-- k("n", "<F2>", ":lua require'dap'.step_over()<CR>", conf)
-- k("n", "<F3>", ":lua require'dap'.step_out()<CR>", conf)
-- k("n", "<space>b", ":lua require'dap'.toggle_breakpoint()<CR>", conf)
-- k("n", "<space>B", ":lua require'dap'.toggle_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", conf)
-- 
-- 
-- Git 
k("n", "<space>g", ":Neogit<CR>", conf)
k("n", "<leade>g", ":G<CR>", conf)
