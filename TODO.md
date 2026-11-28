# Neovim Config TODO

## 1. Neovim 0.11 → 0.12 Modernization

*(Currently running Neovim `v0.12.6`)*

- [ ] **Drop manual `lsp/*.lua` loading**: Remove the `dofile()` loop in `lua/plugins/nvim-lspconfig.lua` (Neovim 0.11+/0.12 auto-loads `lsp/<server>.lua` via `vim.lsp.enable()`).
- [ ] **Simplify `lsp/basedpyright.lua`**: Remove static startup `cwd()` `pyproject.toml` regex parsing and rely on basedpyright's native `pyproject.toml` detection.
- [ ] **Re-enable LSP semantic tokens**: Remove the `semanticTokensProvider = nil` workaround in `lua/configs/lspconfig.lua`.
- [ ] **Reconcile `gr` mapping**: Update `gr` in `lua/configs/lspconfig.lua` so it doesn't collide with Neovim's built-in `grn`/`gra`/`grr`/`gri`/`grt` LSP mappings (eliminates the 400ms `timeoutlen` lag).
- [ ] **Review disabled built-in plugins**: Re-evaluate disabling `"syntax"` and `"ftplugin"` in `lua/configs/lazy.lua` (re-enable if needed by VimTeX / filetype plugins).
- [ ] **Full clean LSP setup & `:lsp`**: Clean up LSP config and adopt Neovim 0.12's built-in `:lsp` command (`:lsp status`, `:lsp restart`, `:lsp enable`, `:lsp stop`).
- [ ] **Verify health**: Run `:Lazy sync` and `:checkhealth` to confirm zero 0.12 deprecation warnings (diagnostics API, treesitter, LSP, `noice.nvim`).
