return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = function()
        return require "configs.avante"
    end,
    build = function()
        local patch = vim.fn.stdpath("config") .. "/lua/configs/patches/avante-reasoning-content.diff"
        if vim.fn.filereadable(patch) == 1 then
            vim.fn.system("git apply --check " .. patch)
            if vim.v.shell_error == 0 then
                vim.notify("avante: applying reasoning_content patch", vim.log.levels.INFO)
                vim.fn.system("git apply " .. patch)
            end
        end
        vim.fn.system("make")
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "echasnovski/mini.pick",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
        "ibhagwan/fzf-lua",
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua",
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    use_absolute_path = true,
                },
            },
        },
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
