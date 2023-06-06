require('orgmode').setup_ts_grammar()

-- Treesitter configuration

require('orgmode').setup({
     org_agenda_files = {'~/orgfiles/tasks.org'},
    --  org_default_notes_file = '~/Dropbox/org/refile.org',
}) 


function setOrgKeybinds()
    local conf = { noremap = true, silent = true }
    local recur = { silent = true }
    local k = vim.api.nvim_set_keymap

    k("i", "<SPACE>a", require("orgmode").action("agenda.prompt"), conf)
end

-- vim.cmd('autocmd FileType org call setOrgKeybinds()')

for i = 1, 40, 1 do
    vim.cmd(string.format("highlight OrgHeadlineLevel%d guibg=NONE", i))
end
require('org-bullets').setup({
    concealcursor = true,
    checkboxes = {
        half = { "", "OrgTSCheckboxHalfChecked" },
        done = { "✓", "OrgDone" },
        todo = { "˟", "OrgTODO" },
    },
})

-- require('headlines').setup({
    --     org = {
        --         fat_headline_lower_string = "▔",
        --     },
        -- })
        -- 
