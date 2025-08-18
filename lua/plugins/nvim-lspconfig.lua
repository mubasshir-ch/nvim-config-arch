local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
  opts = {
    inlay_hints = {
      enabled = true,
    },
  },
  config = function()
    require("nvchad.configs.lspconfig").defaults()
    -- List of LSP servers
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
    }
    vim.lsp.enable(servers)

    -- local lspconfig = require "lspconfig"
    -- local nvlsp = require "nvchad.configs.lspconfig"
    --
    -- -- Define on_attach once
    -- local function on_attach(client, bufnr)
    --   if client.server_capabilities.inlayHintProvider then
    --     vim.lsp.inlay_hint.enable(true)
    --   end
    --   nvlsp.on_attach(client, bufnr)
    -- end
    --
    -- local capabilities = nvlsp.capabilities
    -- capabilities.textDocument.foldingRange = {
    --   dynamicRegistration = false,
    --   lineFoldingOnly = true,
    -- }
    --
    -- local config = {
    --   on_attach = on_attach,
    --   on_init = nvlsp.on_init,
    --   capabilities = capabilities,
    -- }
    --
    --
    -- -- Set up LSP servers
    -- for _, lsp in ipairs(servers) do
    --
    --   lspconfig[lsp].setup(config)
    -- end
  end,
}

return M
