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
    "basedpyright",
    "clangd",
}

local M = {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                ensure_installed = servers,
                automatic_installation = true,
                automatic_enable = false,
            },
        },
    },
    config = function()
        local config = require "configs.lspconfig"

        dofile(vim.g.base46_cache .. "lsp")
        require("nvchad.lsp").diagnostic_config()

        -- Manually set signs if NvChad's diagnostic_config is overwritten
        local x = vim.diagnostic.severity
        vim.diagnostic.config {
            signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
        }

        -- Enable all servers using the native Neovim 0.11+ API
        for _, lsp in ipairs(servers) do
            vim.lsp.config(lsp, {
                on_attach = config.on_attach,
                on_init = config.on_init,
                capabilities = config.capabilities,
            })
            vim.lsp.enable(lsp)
        end
    end,
}

return M
