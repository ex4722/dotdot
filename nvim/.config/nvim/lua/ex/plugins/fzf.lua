return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons", { "junegunn/fzf", build = "./install --bin" } },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({})
    local keymap = vim.keymap
    keymap.set("n", "<leader>pf","<cmd>FzfLua files<CR>" , { desc = "Project find file" })
    keymap.set("n", "<leader>pr", "<cmd>FzfLua live_grep_native<CR>", { desc = "Project rip grep" })
    keymap.set("n", "<C-x><C-b>", "<cmd>FzfLua buffers<CR>", { desc = "Emacs buffer moment" })
  end
}
