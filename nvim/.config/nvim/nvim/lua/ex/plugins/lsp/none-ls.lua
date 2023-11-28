return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        local null_ls_utils = require("null-ls.utils")
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters
        local formatting = null_ls.builtins.formatting -- to setup formatters
        -- configure null_ls
        null_ls.setup({
            -- add package.json as identifier for root (for typescript monorepos)
            root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
            -- setup formatters & linters
            sources = {
                --  to disable file types use
                --  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
                formatting.prettier.with({
                    extra_filetypes = { "svelte" },
                }), -- js/ts formatter
                formatting.stylua, -- lua formatter
                formatting.isort,
                formatting.black,
                diagnostics.pylint,
                diagnostics.eslint_d.with({ -- js/ts linter
                condition = function(utils)
                    return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
                end,
            }),
        },
    })
end
}
