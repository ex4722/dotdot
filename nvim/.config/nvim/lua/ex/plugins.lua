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

vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerInstall
augroup end
]])

local packer = require("packer")
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

return require('packer').startup(function(use)
    -- Core Package
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'


    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'ms-jpq/coq_nvim'
    use {'ms-jpq/coq.artifacts', branch= 'artifacts'}
    use 'jubnzv/virtual-types.nvim'
    use 'glepnir/lspsaga.nvim'
    use 'gfanto/fzf-lsp.nvim'
    use 'ray-x/lsp_signature.nvim'

    -- Grepper
    use 'nvim-pack/nvim-spectre'


    -- Quality of Life 
    use 'mbbill/undotree'
    use 'tpope/vim-commentary'
    use 'mattn/emmet-vim'


    -- Git 
    use 'TimUntersberger/neogit'

    -- Treees
    use 'nvim-treesitter/nvim-treesitter'
    use 'p00f/nvim-ts-rainbow'
    use 'windwp/nvim-autopairs'
    use 'nvim-treesitter/nvim-treesitter-context'
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }




    -- Telly
    use 'junegunn/fzf.vim'
    use 'junegunn/fzf'


    -- Theme  
    use 'kdheepak/tabline.nvim'
    use "lifepillar/vim-solarized8"
    use "kyazdani42/nvim-web-devicons"
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'nvim-tree/nvim-tree.lua'
    use 'onsails/lspkind.nvim'

    -- Dab on dem
    use 'mfussenegger/nvim-dap'
    use 'mfussenegger/nvim-dap-python'
    use 'rcarriga/nvim-dap-ui'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'nvim-telescope/telescope-dap.nvim'



    if packer_bootstrap then
        require('packer').sync()
    end
end)
