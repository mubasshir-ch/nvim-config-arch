# Neovim Config & AI Workflow TODO

## 1. Outdated Plugins, Configs & Bug Fixes

- [x] **Update Mason repos**: Switch `williamboman/mason.nvim` and `williamboman/mason-lspconfig.nvim` to `mason-org/*` and remove deprecated `automatic_installation = true` (`lua/plugins/mason.lua`, `lua/plugins/nvim-lspconfig.lua`).
- [x] **Replace archived `dressing.nvim`**: Removed `dressing.nvim` with `avante.nvim` and configured `folke/snacks.nvim` (`picker.ui_select`, `input`, `notifier`) in `lua/plugins/snacks.lua`.
- [ ] **Migrate `obsidian.nvim`**: Switch `epwalsh/obsidian.nvim` to the active `obsidian-nvim/obsidian.nvim` fork and enable native `blink.cmp` completion (`lua/plugins/obsidian.lua`).
- [x] **Fix `nvim-treesitter` (`main` branch)**: Add `branch = "main"`, `build = ":TSUpdate"`, `lazy = false`; install `tree-sitter` CLI; drop ignored `ensure_installed`/`highlight` from `setup()`; exclude `tex` from `vim.treesitter.start()` so VimTeX regex highlighting/conceal works (`lua/plugins/nvim-treesitter.lua`, `lua/configs/treesitter.lua`, `lua/core/autocmds.lua`).
- [x] **Remove `nvim-cmp` leftovers**: Replaced manual capabilities in `lua/configs/lspconfig.lua` with `blink.cmp`, removed `nvim-cmp` from `lua/plugins/blink.lua` and `lazy-lock.json` (kept `ui.cmp` in `nvconfig.lua` since `nvchad.blink` reads it).
- [x] **Fix keymap collisions & bugs** (`lua/core/mappings.lua`):
  - [x] Resolve `<leader>h` collision between horizontal terminal and Harpoon (`lua/plugins/harpoon.lua`).
  - [x] Resolve Insert-mode `<C-j>/<C-k>/<C-l>` collision with inline completion (`lua/plugins/copilot.lua`).
  - [x] Fix Insert-mode `<C-a>` typing `gg0VG$` literally (and decide whether to keep `<C-a>` in Normal mode).
  - [x] Deduplicate `<C-h>` (Insert), `<C-h/j/k/l>` (Normal), `<C-s>`, and `<leader>ca`.
- [x] **Deduplicate options** (`lua/core/options.lua`): Remove conflicting 2 vs 4 space indent, duplicate `fillchars`, duplicate `autoread`, and `FoldColumn` highlight reset.
- [x] **Minor cleanups**:
  - [x] Fix ignored top-level `timeout_ms` in `lua/configs/conform.lua` (raise `format_on_save.timeout_ms`).
  - [x] Detect `.venv`/`$VIRTUAL_ENV` instead of hardcoding `/usr/bin/python3` in `lua/plugins/nvim-dap.lua`.
  - [x] Lazy-load `vim-be-good` on `cmd = "VimBeGood"` (`lua/plugins/vim-be-good.lua`).
  - [x] Scope VimTeX `conceallevel`/`concealcursor` to `FileType tex` (`lua/plugins/vimtex.lua`).
  - [x] Delete empty `nvim.log`.

---

## 2. Neovim 0.11 → 0.12 Modernization

*(Currently running Neovim `v0.12.6`)*

- [ ] **Drop manual `lsp/*.lua` loading**: Remove the `dofile()` loop in `lua/plugins/nvim-lspconfig.lua` (Neovim 0.11+/0.12 auto-loads `lsp/<server>.lua` via `vim.lsp.enable()`).
- [ ] **Simplify `lsp/basedpyright.lua`**: Remove static startup `cwd()` `pyproject.toml` regex parsing and rely on basedpyright's native `pyproject.toml` detection.
- [x] **Use `blink.cmp` LSP capabilities**: Merge `require("blink.cmp").get_lsp_capabilities()` into `vim.lsp.config("*", ...)` (`lua/configs/lspconfig.lua`, `lua/plugins/nvim-lspconfig.lua`).
- [ ] **Re-enable LSP semantic tokens**: Remove the `semanticTokensProvider = nil` workaround in `lua/configs/lspconfig.lua`.
- [ ] **Reconcile `gr` mapping**: Update `gr` in `lua/configs/lspconfig.lua` so it doesn't collide with Neovim's built-in `grn`/`gra`/`grr`/`gri`/`grt` LSP mappings (eliminates the 400ms `timeoutlen` lag).
- [ ] **Remove hardcoded `wl-clipboard`**: Drop the manual clipboard block in `lua/core/options.lua` and rely on native Wayland/SSH clipboard detection.
- [ ] **Review disabled built-in plugins**: Re-evaluate disabling `"syntax"` and `"ftplugin"` in `lua/configs/lazy.lua` (re-enable if needed by VimTeX / filetype plugins).
- [ ] **Verify health**: Run `:Lazy sync` and `:checkhealth` to confirm zero 0.12 deprecation warnings (diagnostics API, treesitter, LSP, `noice.nvim`).
- [ ] **Optional 0.12 exploration**:
  - [ ] Try native `in`/`an` treesitter incremental selection, `:restart`, and `:lsp`.
  - [ ] Evaluate if `noice.nvim` is still needed with 0.12's reduced "Press ENTER" prompts.
  - [ ] Keep `lazy.nvim` (recommended for NvChad) vs experimenting with `vim.pack`.

---

## 3. AI Workflow Setup (`sidekick.nvim` + `99` & Inline Completion)

- [x] **Replace `avante.nvim` with lighter workflow**: Removed `avante.nvim` (`951dfe3`) in favor of `sidekick.nvim` + `99`.
- [x] **Set up `sidekick.nvim`** (`lua/plugins/sidekick.lua`): Configured `agy`, `opencode`, and `pi` CLI tools, NES (`<C-;>`), and `save_without_format()` on send.
- [x] **Set up `99`** (`lua/plugins/99.lua`, `lua/configs/99.lua`): Configured `AgyProvider`, `OpenCodeProvider`, `PiProvider`, `LlamaProvider`, `DeepSeekProvider`, Harpoon + current-file context (`<leader>9v` / `<leader>9f`), and `vim.ui.select` pickers.
- [x] **Decide on `mcphub.nvim`**: Removed `lua/plugins/mcphub.lua`.
- [x] **Choose inline code completion**: Kept `copilot.lua` for inline ghost text (with `<C-j>/<C-k>/<C-l>` fixed) alongside `sidekick.nvim` NES (`<C-;>`).
