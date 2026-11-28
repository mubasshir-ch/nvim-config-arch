return {
    "ThePrimeagen/99",
    event = "VeryLazy",
    keys = {
        {
            "<leader>9v",
            function()
                require("configs.99").visual(true)
            end,
            mode = "v",
            desc = "99: Visual Inline Edit (Current + Harpoon)",
        },
        {
            "<leader>9f",
            function()
                require("configs.99").visual(false)
            end,
            mode = "v",
            desc = "99: Visual Inline Edit (Current File Only)",
        },
        {
            "<leader>9s",
            function()
                require("99").search()
            end,
            mode = "n",
            desc = "99: Search",
        },
        {
            "<leader>9x",
            function()
                require("99").stop_all_requests()
            end,
            mode = "n",
            desc = "99: Stop All Requests",
        },
        {
            "<leader>9p",
            function()
                require("configs.99").select_provider()
            end,
            mode = "n",
            desc = "99: Select Provider",
        },
        {
            "<leader>9m",
            function()
                require("configs.99").select_model()
            end,
            mode = "n",
            desc = "99: Select Model",
        },
    },
    config = function()
        require("configs.99").setup()
    end,
}
