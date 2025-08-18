local M = {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      auto_trigger = true, -- show suggestions automatically
      keymap = {
        accept = "<C-j>", -- accept entire suggestion
        accept_word = "<C-l>", -- accept a single word
        dismiss = "<C-k>", -- dismiss suggestion
      },
    },
    panel = { enabled = false }, -- disable side panel if you don't use it
    filetypes = {
      ["*"] = true, -- enable for all filetypes
    },
  },
}

return M
