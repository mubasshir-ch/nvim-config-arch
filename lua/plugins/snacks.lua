return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        picker = {
            enabled = true,
            ui_select = true,
        },
        input = {
            enabled = true,
        },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
    },
}
