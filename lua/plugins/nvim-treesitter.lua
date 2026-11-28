return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-context", lazy = false },
        {
            "windwp/nvim-ts-autotag",
            event = { "BufReadPre", "BufNewFile" },
            opts = {
                opts = {
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = false, -- Auto close on trailing </
                },
            },
        },
    },
    config = function()
        require("nvim-treesitter").setup()

        if vim.fn.executable "tree-sitter" == 1 then
            local ts_cfg = require "configs.treesitter"
            require("nvim-treesitter").install(ts_cfg.ensure_installed)
        end
    end,
}
