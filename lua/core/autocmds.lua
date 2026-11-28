local autocmd = vim.api.nvim_create_autocmd

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft ~= "tex" and ft ~= "plaintex" and ft ~= "bib" then
      pcall(vim.treesitter.start, args.buf)
    end
  end,
})

local create_cmd = vim.api.nvim_create_user_command

create_cmd("TSInstallAll", function()
  local ts_cfg = require "configs.treesitter"
  require("nvim-treesitter").install(ts_cfg.ensure_installed)
end, {})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    callback = function()
        if vim.fn.mode() ~= 'c' then
            vim.cmd("checktime")
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    group = vim.api.nvim_create_augroup("MarkdownCheckboxToggle", { clear = true }),
    callback = function(args)
        local buf = args.buf
        local vault = vim.fs.normalize(vim.fn.expand "~/obsidian-vault")
        local name = vim.fs.normalize(vim.api.nvim_buf_get_name(buf))
        if name:sub(1, #vault) == vault then
            return
        end
        vim.keymap.set("n", "<CR>", function()
            local line = vim.api.nvim_get_current_line()
            local prefix, state, rest = line:match "^(%s*[-*+] )%[(.)%](.*)$"
            if not prefix then
                prefix, state, rest = line:match "^(%s*%d+[%.%)] )%[(.)%](.*)$"
            end
            if prefix then
                local next_state = (state == " ") and "x" or " "
                vim.api.nvim_set_current_line(prefix .. "[" .. next_state .. "]" .. rest)
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
            end
        end, { buffer = buf, desc = "Toggle markdown checkbox" })
    end,
})

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("AutoSave", { clear = true }),
    callback = function(args)
        local buf = args.buf
        if
            vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].modified
            and vim.bo[buf].buftype == ""
            and vim.bo[buf].modifiable
            and vim.api.nvim_buf_get_name(buf) ~= ""
        then
            vim.api.nvim_buf_call(buf, function()
                vim.cmd "silent! noautocmd write"
            end)
        end
    end,
})
