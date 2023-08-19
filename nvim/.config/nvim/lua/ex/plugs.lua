-- Lazy Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable", -- latest stable release
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        -- Core
        "nvim-lua/plenary.nvim",
        'rcarriga/nvim-notify',
        -- LSP/Intel
        'neovim/nvim-lspconfig',
        { "williamboman/mason.nvim", run = ":MasonUpdate"},
        'VonHeikemen/lsp-zero.nvim',
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',
        'FelipeLema/cmp-async-path',
        'f3fora/cmp-spell',
        { "L3MON4D3/LuaSnip", version = "1.*", build = "make install_jsregexp" },
        'saadparwaiz1/cmp_luasnip',
        'windwp/nvim-autopairs',
        -- Treesitter
        {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'},
        -- Eye Candy 
        'dccsillag/magma-nvim',
        "lifepillar/vim-solarized8",
        "nvim-tree/nvim-web-devicons",
        'HiPhish/nvim-ts-rainbow2',
        { "snelling-a/better-folds.nvim", config = function() require("better-folds").setup() end },
        -- Shortcuts
        'machakann/vim-sandwich',
        {"Cassin01/wf.nvim", version = "*", config = function() require("wf").setup() end},
        'tpope/vim-commentary',
        -- Mangement
        'mbbill/undotree',
        -- {
        --         "ecthelionvi/NeoComposer.nvim",
        --         dependencies = { "kkharji/sqlite.lua" },
        --         opts = {}
        -- },
        'tpope/vim-obsession',
        'dhruvasagar/vim-prosession',
        'ThePrimeagen/harpoon',
        -- Telly
        'nvim-telescope/telescope.nvim',
        'BurntSushi/ripgrep',
        'sharkdp/fd',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        -- git 
        'NeogitOrg/neogit',
        "sindrets/diffview.nvim",
        'lewis6991/gitsigns.nvim',
})
