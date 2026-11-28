local vault_path = vim.fn.expand "~/obsidian-vault"

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
        "BufReadPre " .. vault_path .. "/**.md",
        "BufNewFile " .. vault_path .. "/**.md",
    },
    cond = function()
        return vim.fn.isdirectory(vault_path) == 1
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Obsidian: Today's Note" },
        { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Obsidian: Yesterday's Note" },
        { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian: New Note" },
        { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian: Search Vault" },
        { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: Quick Switch Note" },
        { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian: Show Backlinks" },
        { "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "Obsidian: Search Tags" },
        { "<leader>oi", "<cmd>Obsidian template<cr>", desc = "Obsidian: Insert Template" },
        { "<leader>ol", "<cmd>Obsidian link<cr>", desc = "Obsidian: Link Relation" },
        { "<leader>op", "<cmd>Obsidian paste_img<cr>", desc = "Obsidian: Paste Image" },
        { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Obsidian: Open in App" },
        { "<leader>ol", ":Obsidian link<cr>", mode = "v", desc = "Obsidian: Link Selection" },
        { "<leader>on", ":Obsidian link_new<cr>", mode = "v", desc = "Obsidian: New Note from Selection" },
    },
    opts = {
        legacy_commands = false,
        workspaces = {
            {
                name = "personal",
                path = "~/obsidian-vault/",
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
            blink = true,
            nvim_cmp = false,
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
        ui = {
            enable = true,
            update_debounce = 200,
            checkboxes = {
                [" "] = { char = "☐", hl_group = "ObsidianTodo" },
                ["x"] = { char = "✔", hl_group = "ObsidianDone" },
            },
        },
    },
}
