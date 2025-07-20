require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

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
  require("nvchad.term").runner {
    id = "horizontalTerm",
    pos = "sp",

    cmd = function()
      local file = vim.fn.expand "%"
      local fNoExt = file:gsub("%..*", "")

      local ft_cmds = {
        python = "python3 " .. file,
        cpp = "clear && g++ --std=c++17 -DLOCAL -Wall -Wextra -Wshadow -O2 -lm -o "
          .. fNoExt
          .. " "
          .. file
          .. " && ./"
          .. fNoExt
          .. " <in.txt | tee out.txt",
      }
      -- print(ft_cmds["cpp"])

      return ft_cmds[vim.bo.ft]
    end,
  }
end, { desc = "Run code" })

-- Tmux Navigator
--   { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
--   { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
--   { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
--   { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
--   { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux Navigate Left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux Navigate Down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux Navigate Up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux Navigate Right" })
map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Tmux Navigate Previous" })
