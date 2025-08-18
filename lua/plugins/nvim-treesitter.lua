local M = {
  "nvim-treesitter/nvim-treesitter",
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
  opts = {
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
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "latex" }, -- Needed for vimtex!
    },
  },
}

return M
