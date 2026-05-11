local servers = {
    "html",
    "cssls",
    "texlab",
    "ts_ls",
    "jsonls",
    "eslint",
    "tailwindcss",
    "lua_ls",
    "sqlls",
    "gopls",
    "hls",
    "rust_analyzer",
    "prismals",
    -- "basedpyright",
    "clangd",
}

local M = {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                ensure_installed = servers, -- Use the variable here
                automatic_installation = true,
            },
        },
    },
    config = function()
        require("nvchad.configs.lspconfig").defaults()
        local nvlsp = require "nvchad.configs.lspconfig"

        -- Use the same variable here for the loop
        for _, lsp in ipairs(servers) do
            vim.lsp.config(lsp, {
                append_config = {
                    on_attach = nvlsp.on_attach,
                    on_init = nvlsp.on_init,
                    capabilities = nvlsp.capabilities,
                },
            })
            vim.lsp.enable(lsp)
        end
    end,
}

return M
