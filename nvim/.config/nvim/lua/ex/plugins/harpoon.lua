return {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "H",
        function()
            require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Open Harpoons",
      },
      {
        "<leader>h",
        function()
            require("harpoon.mark").add_file()
        end,
        desc = "Add Harpoons",
      },
      {
        "<leader>a",
        function()
            require("harpoon.ui").nav_file(1)
        end,
        desc = "Open file 1",
      },
      {
        "<leader>s",
        function()
            require("harpoon.ui").nav_file(2)
        end,
        desc = "Open file 2",
      },
      {
        "<leader>d",
        function()
            require("harpoon.ui").nav_file(3)
        end,
        desc = "Open file 3",
      },

    }
}
