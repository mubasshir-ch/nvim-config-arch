return {
    "stevearc/conform.nvim",
    event = "User FilePost",
    opts = function()
        return require "configs.conform"
    end,
}
