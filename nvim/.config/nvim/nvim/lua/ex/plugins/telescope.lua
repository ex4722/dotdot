return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "debugloop/telescope-undo.nvim",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

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
                    n = {
                        ["q"] = "close",
                    }
                }
            },
            extensions = {
                fzf = {
                    fuzzy = true,                    -- false will only do exact matching
                    override_generic_sorter = true,  -- override the generic sorter
                    override_file_sorter = true,     -- override the file sorter
                    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                },
                undo = {
                    use_delta = true,
                },
                dress = {}
            }
        }

        telescope.load_extension("fzf")
        telescope.load_extension("undo")
        -- telescope.load_extension("scratch")

        -- Keymaps 
        local keymap = vim.keymap
        keymap.set("n", "<leader>pf","<cmd>Telescope find_files<CR>" , { desc = "Project find file" })
        keymap.set("n", "<leader>pr", "<cmd>Telescope live_grep<CR>", { desc = "Project rip grep" })
        keymap.set("n", "<leader>pg", "<cmd>Telescope grep_string<CR>", { desc = "Project grep word under string" })
        keymap.set("n", "<C-x><C-b>", "<cmd>Telescope buffers<CR>", { desc = "Emacs buffer moment" })
        keymap.set("n", "<leader>u", "<cmd>Telescope undo<CR>", { desc = "Undo shit" })
    end
}
