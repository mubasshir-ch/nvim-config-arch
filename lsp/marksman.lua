local vault = vim.fs.normalize(vim.fn.expand "~/obsidian-vault")

return {
    root_dir = function(bufnr, on_dir)
        local fname = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
        if fname == vault or vim.startswith(fname, vault .. "/") then
            return
        end
        on_dir(vim.fs.root(bufnr, { ".marksman.toml", ".git" }) or vim.fs.dirname(fname))
    end,
}
