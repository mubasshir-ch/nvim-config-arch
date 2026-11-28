local function normalize_path(path)
  if not path or path == "" then
    return ""
  end
  if not vim.startswith(path, "/") then
    path = vim.fs.joinpath(vim.uv.cwd(), path)
  end
  return vim.fs.normalize(path)
end

local function select_or_focus(index)
  local list = require("harpoon"):list()
  local item = list:get(index)
  if item and type(item.value) == "string" and item.value ~= "" then
    local target = normalize_path(item.value)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if normalize_path(vim.api.nvim_buf_get_name(buf)) == target then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end
  list:select(index)
end

local keys = {
  {
    "<A-a>",
    function()
      require("harpoon"):list():add()
    end,
    desc = "Harpoon: Add File",
  },
  {
    "<A-h>",
    function()
      local harpoon = require "harpoon"
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = "Harpoon: Toggle Quick Menu",
  },
}

for i = 1, 9 do
  table.insert(keys, {
    "<A-" .. i .. ">",
    function()
      select_or_focus(i)
    end,
    desc = "Harpoon: File " .. i,
  })
end

local M = {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("harpoon"):setup {
        menu = {
          width = vim.api.nvim_win_get_width(0) - 4,
        },
        settings = {
          save_on_toggle = true,
        },
      }
    end,
    keys = keys,
  },
}

return M
