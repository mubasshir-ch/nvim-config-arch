local map = vim.keymap.set

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map({ "n", "x" }, "<leader>fm", function()
    require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- tabufline
if require("nvconfig").ui.tabufline.enabled then
    map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

    map("n", "<tab>", function()
        require("nvchad.tabufline").next()
    end, { desc = "buffer goto next" })

    map("n", "<S-tab>", function()
        require("nvchad.tabufline").prev()
    end, { desc = "buffer goto prev" })

    map("n", "<leader>x", function()
        require("scope.core").close_buffer()
    end, { desc = "buffer close (smart scope)" })
end
-- Native Tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Only tab" })
map("n", "<leader>ts", "<cmd>tab split<cr>", { desc = "Current buffer in new tab" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fB", "<cmd>Telescope scope buffers<CR>", { desc = "telescope find all buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

map("n", "<leader>th", function()
    require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map("n", "<leader>fr", "<cmd>Telescope resume<cr>", { desc = "telescope resume last search" })
map(
    "n",

    "<leader>fa",
    "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
    { desc = "telescope find all files" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
    require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
    require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
    require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
    require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
    require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
    vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- add yours here

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- toggle inlay hints
map("n", "<leader>i", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- map ctrl + s to save (:w)
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Copilot
map("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
    -- silent = true,
    -- script = true,
    desc = "Copilot Accept Suggestion",
})

map("i", "<C-l>", "<Plug>(copilot-accept-word)", {
    -- silent = true,
    -- script = true,
    desc = "Copilot Accept Word",
})

map("i", "<C-k>", "copilot#Dismiss()", {
    expr = true,
    -- silent = true,
    -- script = true,
    desc = "Copilot Dismiss",
})

-- map ctrl + a to select all
map({ "n", "i", "v" }, "<C-a>", "gg0VG$", { noremap = true, silent = true })

-- Terminal Toggle
map({ "n", "t" }, "<F2>", function()
    require("nvchad.term").toggle { pos = "sp", id = "horizontalTerm" }
end)

map({ "n", "t" }, "<F3>", function()
    require("nvchad.term").toggle { pos = "vsp", id = "verticalTerm" }
end)

map({ "n", "t" }, "<F4>", function()
    require("nvchad.term").toggle { pos = "float", id = "floatingTerm" }
end)

-- Changing indentation
map("n", "<leader>ti", function()
    if vim.opt.shiftwidth:get() == 2 then
        -- Switch to 4-space indentation
        vim.opt.shiftwidth = 4
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.expandtab = true
        print "Switched to 4-space indentation"
    else
        -- Switch to 2-space indentation
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.expandtab = true
        print "Switched to 2-space indentation"
    end
end, { desc = "Toggle between 2-space and 4-space indentation" })

map("n", "<F5>", function()
    local file = vim.fn.expand "%"
    local fNoExt = vim.fn.expand "%:r"
    local exe = fNoExt
    if not exe:match "^/" and not exe:match "^%./" then
        exe = "./" .. exe
    end
    local ft = vim.bo.filetype
    require("nvchad.term").runner {
        id = "horizontalTerm",
        pos = "sp",
        cmd = function()
            local ft_cmds = {
                python = "python3 " .. file,
                cpp =
                    "clear && g++ --std=c++23 -DLOCAL -Wall -Wextra -Wshadow -O2 -lm -g -fsanitize=address,undefined -o "
                    .. exe
                    .. " "
                    .. file
                    .. " && "
                    .. exe
                    .. " <in.txt | tee out.txt",
            }
            return ft_cmds[ft]
        end,
    }
end, { desc = "Run code" })

map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right" })
map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Tmux Navigate Previous" })

map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })

-- map ctrl + backspace to delete the previous word
map("i", "<C-h>", "<C-w>", { noremap = true, silent = true, desc = "Delete previous word" })

-- Minty (Color Picker)
map("n", "<leader>cp", "<cmd>Huefy<cr>", { desc = "Pick Color" })

-- Menu
map("n", "<C-t>", function()
    require("menu").open("default")
end, { desc = "Open Menu" })

map("n", "<RightMouse>", function()
    vim.cmd.exec '"normal! \\<RightMouse>"'
    local menu = require("menu")
    menu.open("default")
end, { desc = "Open Menu" })
