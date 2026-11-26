local function save_without_format()
    if vim.bo.modified and vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= "" then
        vim.cmd "silent! noautocmd write"
    end
end

return {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
        nes = {
            enabled = true,
        },
        cli = {
            tools = {
                antigravity = {
                    cmd = { "agy" },
                },
                opencode = {
                    cmd = { "opencode" },
                },
                pi = {
                    cmd = { "pi" },
                },
            },
        },
    },
    keys = {
        {
            "<C-;>",
            function()
                require("sidekick").nes_jump_or_apply()
            end,
            mode = { "n", "i" },
            desc = "Goto/Apply Next Edit Suggestion",
        },
        {
            "<c-.>",
            function()
                require("sidekick.cli").toggle()
            end,
            desc = "Sidekick Toggle",
            mode = { "n", "t", "i", "x" },
        },
        {
            "<leader>aa",
            function()
                require("sidekick.cli").toggle()
            end,
            desc = "Sidekick Toggle CLI",
        },
        {
            "<leader>as",
            function()
                require("sidekick.cli").select()
            end,
            desc = "Select CLI",
        },
        {
            "<leader>ad",
            function()
                require("sidekick.cli").close()
            end,
            desc = "Detach a CLI Session",
        },
        {
            "<leader>at",
            function()
                save_without_format()
                require("sidekick.cli").send { msg = "{this}" }
            end,
            mode = { "x", "n" },
            desc = "Send This",
        },
        {
            "<leader>af",
            function()
                save_without_format()
                require("sidekick.cli").send { msg = "{file}" }
            end,
            desc = "Send File",
        },
        {
            "<leader>av",
            function()
                save_without_format()
                require("sidekick.cli").send { msg = "{selection}" }
            end,
            mode = { "x" },
            desc = "Send Visual Selection",
        },
        {
            "<leader>ap",
            function()
                save_without_format()
                require("sidekick.cli").prompt()
            end,
            mode = { "n", "x" },
            desc = "Sidekick Select Prompt",
        },
        {
            "<leader>ac",
            function()
                require("sidekick.cli").toggle { name = "antigravity", focus = true }
            end,
            desc = "Sidekick Toggle Antigravity",
        },
    },
}
