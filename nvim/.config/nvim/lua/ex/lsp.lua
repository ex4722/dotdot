-- hi jermely
local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn",  text = "" },
    { name = "DiagnosticSignHint",  text = "" },
    { name = "DiagnosticSignInfo",  text = "" },
}
for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "", guibg = "#073642" })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
        active = signs,
    },

    update_in_insert = true,
    underline = true,
    severity_sort = true,

    float = {
        focusable = false,
        style = "minimal",
        -- border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
}

vim.diagnostic.config(config)



-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason").setup()
local lspconfig = require('lspconfig')

lspconfig.pyright.setup({
    capabilities = capabilities
})
lspconfig.tsserver.setup({
    capabilities = capabilities
})
lspconfig.clangd.setup({
    capabilities = capabilities
})

-- Lua Stuff
local zero = require('lsp-zero').preset({})
lspconfig.lua_ls.setup(zero.nvim_lua_ls())


vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        -- wtf is this lOL
        -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gf', ":Format<CR>", opts)
    end,
})


-- Formatter shit
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    python = {
      require("formatter.filetypes.python").black,
    },
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

      -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
    },



    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}
