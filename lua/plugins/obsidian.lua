return {
    "epwalsh/obsidian.nvim",
    version = "*", -- use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>od", "<cmd>ObsidianToday<cr>",       desc = "Obsidian: Today's Note" },
        { "<leader>oy", "<cmd>ObsidianYesterday<cr>",   desc = "Obsidian: Yesterday's Note" },
        { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "Obsidian: New Note" },
        { "<leader>os", "<cmd>ObsidianSearch<cr>",      desc = "Obsidian: Search Vault" },
        { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: Quick Switch Note" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<cr>",   desc = "Obsidian: Show Backlinks" },
        { "<leader>ot", "<cmd>ObsidianTags<cr>",        desc = "Obsidian: Search Tags" },
        { "<leader>oi", "<cmd>ObsidianTemplate<cr>",    desc = "Obsidian: Insert Template" },
        { "<leader>ol", "<cmd>ObsidianLink<cr>",        desc = "Obsidian: Link Relation" },
        { "<leader>op", "<cmd>ObsidianPasteImg<cr>",    desc = "Obsidian: Paste Image" },
        { "<leader>oo", "<cmd>ObsidianOpen<cr>",        desc = "Obsidian: Open in App" },
        { "<leader>ol", ":ObsidianLink<cr>",            mode = "v",                          desc = "Obsidian: Link Selection" },
        { "<leader>on", ":ObsidianLinkNew<cr>",         mode = "v",                          desc = "Obsidian: New Note from Selection" },
    },
    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/Obsidian Vault/",
            },
        },
        daily_notes = {
            folder = "dailies",
            date_format = "%Y-%m-%d",
            alias_format = "%B %d, %Y",
            template = "daily.md",
        },
        templates = {
            folder = "templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            substitutions = {},
        },
        completion = {
            nvim_cmp = false, -- Disable nvim-cmp integration since blink.cmp is used
            min_chars = 2,
        },
        -- Custom note ID function to keep file names human-readable
        note_id_func = function(title)
            if title ~= nil then
                -- Slugify title (e.g., "My Note" -> "my-note")
                return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-_]", ""):lower()
            else
                -- Fallback to epoch timestamp if no title is provided
                return tostring(os.time())
            end
        end,
        -- Optional, configure bullet formatting for checkboxes
        ui = {
            enable = true,
            update_debounce = 200,
            checkboxes = {
                -- Custom characters or icons for checkboxes
                [" "] = { char = "☐", hl_group = "ObsidianTodo" },
                ["x"] = { char = "✔", hl_group = "ObsidianDone" },
            },
        },
    },
}
