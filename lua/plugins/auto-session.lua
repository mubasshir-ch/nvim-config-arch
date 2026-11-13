local M = {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",              -- Only needed if you want to use session lens
    },
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        bypass_save_filetypes = { "alpha", "dashboard", "nvdash" }, -- or whatever dashboard you use
        suppressed_dirs = { "~/", "~/productivity/", "~/Downloads", "/" },
        -- log_level = 'debug',
        auto_save = true,
        auto_restore = true,
        auto_restore_last_session = false,
        args_allow_files_auto_save = true,
    },
    keys = {
        -- Will use Telescope if installed or a vim.ui.select picker otherwise
        { "<leader>sr", "<cmd>AutoSession search<CR>",    desc = "Session search" },
        { "<leader>ss", "<cmd>AutoSession save<CR>",      desc = "Save session" },
        { "<leader>sa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
    },
}

return M
