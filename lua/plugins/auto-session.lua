local M = {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",              -- Only needed if you want to use session lens
    },
    bypass_save_filetypes = { "alpha", "dashboard" }, -- or whatever dashboard you use
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        suppressed_dirs = { "~/", "~/productivity/", "~/Downloads", "/" },
        -- log_level = 'debug',
        auto_restore_last_session = false,
    },
    keys = {
        -- Will use Telescope if installed or a vim.ui.select picker otherwise
        { "<leader>sr", "<cmd>AutoSession search<CR>",    desc = "Session search" },
        { "<leader>ss", "<cmd>AutoSession save<CR>",      desc = "Save session" },
        { "<leader>sa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
    },
}

return M
