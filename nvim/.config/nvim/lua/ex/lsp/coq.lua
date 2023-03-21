vim.g.coq_settings = {
    auto_start = 'shut-up',
    clients = {
        lsp = {
            always_on_top = {},
        },
        paths = {
            always_on_top = true,
        },
        tmux= {
            enabled = false,
        },
    },
    keymap = {
        -- manual_complete = "<c-h>",
        pre_select = false,
    },
    display ={
        ghost_text = {
            enabled = false,
        },
        preview = {
            border = {
            {"", "NormalFloat"},
            {"", "NormalFloat"},
            {"", "NormalFloat"},
            {" ", "NormalFloat"},
            {"", "NormalFloat"},
            {"", "NormalFloat"},
            {"", "NormalFloat"},
            {" ", "NormalFloat"}
            }

        },

        mark_highlight_group = "ErrorMsg",
        icons = {
            spacing=1,
            mappings = {
                Text = "",
                Method = "m",
                Function = "",
                Constructor = "",
                Field = "",
                Variable = "",
                Class = "",
                Interface = "",
                Module = "",
                Property = "",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",

            }

        }
    }
}
-- local coq = require "coq" -- add this
--

local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')
-- _G.MUtils= {}
-- MUtils.CR = function()
--   if vim.fn.pumvisible() ~= 0 then
--     if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
--       return npairs.esc('<c-y>')
--     else
--       return npairs.esc('<c-e>') .. npairs.autopairs_cr()
--     end
--   else
--     return npairs.autopairs_cr()
--   end
-- end
-- remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

-- MUtils.BS = function()
--   if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
--     return npairs.esc('<c-e>') .. npairs.autopairs_bs()
--   else
--     return npairs.autopairs_bs()
--   end
-- end
-- remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
npairs.setup({ map_cr = true })
