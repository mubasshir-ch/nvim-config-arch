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
    "marksman",
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

        -- Set global diagnostic signs
        local x = vim.diagnostic.severity
        vim.diagnostic.config {
            signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
        }

        -- Set global defaults for all servers
        vim.lsp.config("*", {
            on_init = config.on_init,
            capabilities = config.capabilities,
        })

        -- Setup on_attach logic (keymaps, etc.) via autocommand
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client then
                    config.on_attach(client, args.buf)
                end
            end,
        })

        -- Enable all servers
        for _, lsp in ipairs(servers) do
            -- Load user custom config if it exists (~/.config/nvim/lsp/server.lua)
            local custom_opts_path = vim.fn.stdpath "config" .. "/lsp/" .. lsp .. ".lua"
            if vim.fn.filereadable(custom_opts_path) == 1 then
                vim.lsp.config(lsp, dofile(custom_opts_path))
            end

            vim.lsp.enable(lsp)
        end
    end,
}

return M
