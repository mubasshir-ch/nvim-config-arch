local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettier" },
        html = { "prettier" },
        python = { "black" },
        tex = { "latexindent" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        cpp = { "clang_format" },
        markdown = { "prettier" },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 2500,
        lsp_format = "fallback",
        async = false,
    },
    formatters = {
        clang_format = {
            command = "clang-format",
        },
    },
    notify_on_error = true,
}

return options
