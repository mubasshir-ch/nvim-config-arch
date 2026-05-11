return {
    "nvim-treesitter/nvim-treesitter",
    event = "User FilePost",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-context", lazy = false },
        {
            "windwp/nvim-ts-autotag",
            event = { "BufReadPre", "BufNewFile" },
            opts = {
                -- Defaults
                enable_close = true, -- Auto close tags
                enable_rename = true, -- Auto rename pairs of tags
                enable_close_on_slash = false, -- Auto close on trailing </
            },
        },
    },
    opts = function()
        return require "configs.treesitter"
    end,
    config = function(_, opts)
        require("nvim-treesitter").setup(opts)
    end,
}
