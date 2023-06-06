local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
return require('packer').startup(function(use)
    -- Core Packages 
    use 'wbthomason/packer.nvim'
    use "nvim-lua/plenary.nvim"

    -- Themes
    use "nvim-tree/nvim-web-devicons"
    use "lifepillar/vim-solarized8"
    use "nvim-lualine/lualine.nvim"


    -- Tools
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "MunifTanjim/nui.nvim",
        }
    }
    use 'ThePrimeagen/harpoon'
    use 'mbbill/undotree'
    use 'TimUntersberger/neogit'

    use {
        'lewis6991/gitsigns.nvim',
        -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    }

    use 'edKotinsky/Arduino.nvim'
    use 'tpope/vim-commentary'


    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter', 
        run = ":TSUpdate"
    }

    -- TELLY
    use {'nvim-telescope/telescope.nvim', tag = '0.1.1'}

    -- Orgmode 
    use 'nvim-orgmode/orgmode' 
    use 'akinsho/org-bullets.nvim'
    use 'lukas-reineke/headlines.nvim'

    -- Lsp 
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP 
    use 'williamboman/mason.nvim'
    use "williamboman/mason-lspconfig.nvim"
    use 'mfussenegger/nvim-lint'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'glepnir/lspsaga.nvim'
    use 'onsails/lspkind.nvim'
    use 'ms-jpq/coq_nvim'

    use "windwp/nvim-autopairs"

    -- Cool shit 
    -- use 'tamton-aquib/mpv.nvim'
    -- use { 'tamton-aquib/flirt.nvim' }
    use 'nanozuki/tabby.nvim'
    use 'kdheepak/tabline.nvim'

    use 'mattn/emmet-vim'
    -- Dab on em 
    use 'mfussenegger/nvim-dap'
    if packer_bootstrap then
        require('packer').sync()
    end
end)
