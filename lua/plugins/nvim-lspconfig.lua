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
                -- Disable automatic enabling to prevent conflicts with our manual setup
                automatic_enable = false,
            },
        },
    },
    config = function()
        local map = vim.keymap.set

        local on_attach = function(client, bufnr)
            local function opts(desc)
                return { buffer = bufnr, desc = "LSP " .. desc }
            end

            map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
            map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
            map("n", "<leader>gv", function()
                vim.cmd "vsplit"
                vim.lsp.buf.definition()
            end, opts "Go to definition in vertical split")
            map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
            map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
            map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
            map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

            map("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts "List workspace folders")

            map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
            map("n", "<leader>ra", function()
                require("nvchad.lsp.renamer")()
            end, opts "NvRenamer")

            map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
            map("n", "gr", vim.lsp.buf.references, opts "Show references")

            -- basedpyright specific mapping
            if client.name == "basedpyright" then
                map("n", "<leader>tp", function()
                    local modes = { "off", "basic", "standard", "strict", "all" }
                    vim.ui.select(modes, {
                        prompt = "Select Basedpyright Type Checking Mode:",
                    }, function(choice)
                        if choice then
                            client.config.settings.basedpyright.analysis.typeCheckingMode = choice
                            client.notify("workspace/didChangeConfiguration", {
                                settings = client.config.settings,
                            })
                            vim.notify("Basedpyright mode set to: " .. choice)
                        end
                    end)
                end, opts "Change type checking mode")
            end
        end

        local on_init = function(client, _)
            if client:supports_method "textDocument/semanticTokens" then
                client.server_capabilities.semanticTokensProvider = nil
            end
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()

        capabilities.textDocument.completion.completionItem = {
            documentationFormat = { "markdown", "plaintext" },
            snippetSupport = true,
            preselectSupport = true,
            insertReplaceSupport = true,
            labelDetailsSupport = true,
            deprecatedSupport = true,
            commitCharactersSupport = true,
            tagSupport = { valueSet = { 1 } },
            resolveSupport = {
                properties = {
                    "documentation",
                    "detail",
                    "additionalTextEdits",
                },
            },
        }

        dofile(vim.g.base46_cache .. "lsp")
        require("nvchad.lsp").diagnostic_config()

        -- Manually set signs if NvChad's diagnostic_config is overwritten
        local x = vim.diagnostic.severity
        vim.diagnostic.config {
            signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
        }

        local lua_lsp_settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                    library = {
                        vim.fn.expand "$VIMRUNTIME/lua",
                        vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                        vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                        "${3rd}/luv/library",
                    },
                },
            },
        }

        -- Enable all servers using the native Neovim 0.11+ API
        for _, lsp in ipairs(servers) do
            -- We customize the configuration for each server.
            -- Neovim automatically merges this with the default config found in nvim-lspconfig/lsp/
            local config = {
                on_attach = on_attach,
                on_init = on_init,
                capabilities = capabilities,
            }

            -- Merge specific settings
            if lsp == "basedpyright" then
                config.settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "standard",
                        },
                    },
                }
            elseif lsp == "lua_ls" then
                config.settings = lua_lsp_settings
            end

            vim.lsp.config(lsp, config)
            vim.lsp.enable(lsp)
        end
    end,
}

return M
