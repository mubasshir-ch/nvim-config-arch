local M = {}

M.base46 = {
    theme = "material-deep-ocean",
}

M.ui = {
    cmp = {
        icons = true,
        lspkind_text = true,
        style = "flat_dark",
        format_colors = {
            lsp = true,
        },
    },
}

M.nvdash = {
    load_on_startup = true,
    header = {
        "                             ",
        "     ███╗   ██╗██╗   ██╗     ",
        "     ████╗  ██║██║   ██║     ",
        "     ██╔██╗ ██║██║   ██║     ",
        "     ██║╚██╗██║╚██╗ ██╔╝     ",
        "     ██║ ╚████║ ╚████╔╝      ",
        "     ╚═╝  ╚═══╝  ╚═══╝       ",
        "                             ",
        "                             ",
        "                             ",
        "     Powered By eovim      ",
        "                             ",
    },

    buttons = {
        { txt = "󰄉  Search Session", keys = "sr", cmd = "AutoSession search" },
        { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
        { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
        { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
        { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
        { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

        { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

        {
            txt = function()
                local stats = require("lazy").stats()
                local ms = math.floor(stats.startuptime) .. " ms"
                return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
            end,
            hl = "NvDashFooter",
            no_gap = true,
        },

        { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    },
}

return M
