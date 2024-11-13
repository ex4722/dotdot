return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = {},
            sync_install = false,
            highlight = { 
                enable = true, 
                disable = { "latex"},
            },
            indent = { enable = true },  
        })
    end

}
