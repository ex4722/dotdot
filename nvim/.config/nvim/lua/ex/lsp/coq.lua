vim.g.coq_settings = {
    auto_start = true,
    clients = {
        tmux= {
            enabled = false,
        },
    },
    keymap = {
        -- manual_complete = "<c-h>",
        pre_select = false,
    },
    display ={
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
local coq = require "coq" -- add this
