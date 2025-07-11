local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  -- enabled = false,

  opts = {
    -- add any options here
    stages = "static",
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    notify = {
      timeout = 1000, -- 1000ms = 1 second
    },

    routes = {
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
      -- Suppress messages with "line" information after saving
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = [[%".*%".*line]],
        },
        opts = { skip = true },
      },
      -- Suppress messages with "L, B" format (e.g., "33L, 3711B")
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = [[%".*%".*%d+L,%s*%d+B]],
        },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      "rcarriga/nvim-notify",
      opts = {
        render = "compact", -- default, compact, minimal, simple
        timeout = 1000,
        top_down = false,
        max_width = 100,
        background_colour = "#000000",
      },
    },
  },
}

return M
