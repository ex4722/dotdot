return {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
        local null_ls = require("null-ls")
        -- local null_ls_utils = require("null-ls.utils")
        local diagnostics = null_ls.builtins.diagnostics
        local formatting = null_ls.builtins.formatting
        local actions = null_ls.builtins.code_actions
        null_ls.setup({
            -- root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
            sources = {
                diagnostics.alex,
                diagnostics.checkmake,
                -- diagnostics.clang_check,
                -- diagnostics.codespell,
                diagnostics.pylint,
                -- diagnostics.luacheck,
                -- diagnostics.eslint_d.with({
                --     condition = function(utils)
                --         return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
                --     end,
                -- }),

                formatting.stylua,
                formatting.black,
                formatting.isort,
                formatting.clang_format,
                formatting.prettier.with({
                    extra_filetypes = { "svelte" },
                }), -- js/ts formatter

                actions.refactoring,
            },
        })
    end,
}
