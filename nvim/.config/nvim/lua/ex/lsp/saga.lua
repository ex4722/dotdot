require("lspsaga").setup({
    ui = {
        -- Currently, only the round theme exists
        theme = "round",
        -- This option only works in Neovim 0.9
        title = false,
        -- Border type can be single, double, rounded, solid, shadow.
        border = "rounded",
        winblend = 0,
        expand = "",
        collapse = "",
        preview = " ",
        code_action = "💡",
        diagnostic = "🐞",
        incoming = " ",
        outgoing = " ",
        hover = ' ',
        kind = {},
    },
    symbol_in_winbar = {
        enable = false,
    },
        rename = {
            quit = "<C-c>",
            exec = "<CR>",
            mark = "x",
            confirm = "<CR>",
            in_select = true,
        },
    })
