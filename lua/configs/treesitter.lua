local options = {
    ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "c",
        "cpp",
        "latex",
        "markdown",
        "go",
        "rust",
        "dart",
        "java",
        "json",
        "yaml",
        "xml",
        "haskell",
        "php",
        "luadoc",
        "printf",
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "latex" }, -- Needed for vimtex!
    },
}

return options
