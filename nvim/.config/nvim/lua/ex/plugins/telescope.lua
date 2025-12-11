return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
        {'debugloop/telescope-undo.nvim'}
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        require("telescope").load_extension("undo")
        vim.keymap.set("n", "gu", "<cmd>Telescope undo<cr>")



        telescope.setup{
            defaults = {
                file_ignore_patterns = {".git/", ".cache", "%.o", "%.a", "%.out", "%.class",
                "%.pdf", "%.mkv", "%.mp4", "%.zip", "undodir/"},
                mappings = {
                    -- Control J and K to scroll 
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                }
            },
            extensions = {
                fzf = {
                    fuzzy = true,                    -- false will only do exact matching
                    override_generic_sorter = true,  -- override the generic sorter
                    override_file_sorter = true,     -- override the file sorter
                    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                },
                dress = {}
            }
        }

        telescope.load_extension("fzf")
    end
}
