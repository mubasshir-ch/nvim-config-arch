return {
    {
        "hrsh7th/nvim-cmp",
        enabled = false,
    },
    {
        "saghen/blink.cmp",
        version = "1.*",
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            "rafamadriz/friendly-snippets",
            "L3MON4D3/LuaSnip",
            {
                "windwp/nvim-autopairs",
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
            },
        },
        opts_extend = { "sources.default" },
        opts = function()
            -- We can still use the nvchad blink config if the module is available
            -- or define our own. Since nvchad/ui is installed, this should work.
            local ok, config = pcall(require, "nvchad.blink.config")
            if ok then
                return config
            end
            return {} -- Fallback
        end,
    },
}
