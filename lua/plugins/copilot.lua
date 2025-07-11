local M = {
  "github/copilot.vim",
  lazy = false,
  config = function() -- Mapping tab is already used by NvChad
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    vim.g.copilot_node_command = "/home/mub/.nvm/versions/node/v22.17.0/bin/node"
    -- The mapping is set to other key, see custom/lua/mappings
    -- or run <leader>ch to see copilot mapping section
    vim.g.copilot_filetypes = {
      cpp = false,
    }
  end,
}
return M
