local M = {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  cond = function()
    return vim.fn.executable "mcp-hub" == 1
  end,
  config = function()
    require("mcphub").setup()
  end,
}

return M
