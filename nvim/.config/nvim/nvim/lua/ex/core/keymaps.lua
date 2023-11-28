-- Leader to space
vim.g.mapleader = " "

local keymap = vim.keymap 

-- jk > ECS
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Space enter to clear
keymap.set("n", "<leader><CR>", ":nohl<CR>", { desc = "Clear search highlights" })

-- Copy and paste using system
keymap.set("", "<C-p>", "<C-r>+", {desc = "Use Control P to paste from system"})
keymap.set("", "Y", "\"+y", {desc = "Use uppercase Y for system clip(motions work)"})


-- Keeps text selected when shifting 
keymap.set("v", ">", ">gv", {desc = "Selects again"})
keymap.set("v", "<", "<gv", {desc = "Selects again"})
keymap.set("x", ">", ">gv", {desc = "Selects again"})
keymap.set("x", "<", "<gv", {desc = "Selects again"})


-- Keeps place when Joining
keymap.set("n", "J", "mzJ`z", {desc = "Stays in place during join"})

-- Moves lines up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc = "Stays in place during join"})
keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc = "Stays in place during join"})
keymap.set("x", "J", ":m '>+1<CR>gv=gv", {desc = "Stays in place during join"})
keymap.set("x", "K", ":m '<-2<CR>gv=gv", {desc = "Stays in place during join"})

-- Faster save 2 keys instead of 4
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Faster Save" })
