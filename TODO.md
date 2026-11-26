# Neovim Config & AI Workflow TODO

## 1. Outdated Plugins, Configs & Bug Fixes

- [ ] **Update Mason repos**: Switch `williamboman/mason.nvim` and `williamboman/mason-lspconfig.nvim` to `mason-org/*` and remove deprecated `automatic_installation = true` (`lua/plugins/mason.lua`, `lua/plugins/nvim-lspconfig.lua`).
- [ ] **Replace archived `dressing.nvim`**: Swap `stevearc/dressing.nvim` for `folke/snacks.nvim` (`lua/plugins/avante.lua`).
- [ ] **Migrate `obsidian.nvim`**: Switch `epwalsh/obsidian.nvim` to the active `obsidian-nvim/obsidian.nvim` fork and enable native `blink.cmp` completion (`lua/plugins/obsidian.lua`).
- [ ] **Fix `nvim-treesitter` (`main` branch)**: Add `branch = "main"`, `build = ":TSUpdate"`, `lazy = false`; install `tree-sitter` CLI; drop ignored `ensure_installed`/`highlight` from `setup()`; exclude `tex` from `vim.treesitter.start()` so VimTeX regex highlighting/conceal works (`lua/plugins/nvim-treesitter.lua`, `lua/configs/treesitter.lua`, `lua/core/autocmds.lua`).
- [ ] **Remove `nvim-cmp` leftovers**: Replace manual capabilities in `lua/configs/lspconfig.lua` with `blink.cmp`, clean `ui.cmp` in `lua/configs/nvconfig.lua`, and remove `nvim-cmp` from `lazy-lock.json`.
- [ ] **Fix keymap collisions & bugs** (`lua/core/mappings.lua`):
  - [ ] Resolve `<leader>h` collision between horizontal terminal and Harpoon (`lua/plugins/harpoon.lua`).
  - [ ] Resolve Insert-mode `<C-j>/<C-k>/<C-l>` collision with inline completion (`lua/plugins/copilot.lua`).
  - [ ] Fix Insert-mode `<C-a>` typing `gg0VG$` literally (and decide whether to keep `<C-a>` in Normal mode).
  - [ ] Deduplicate `<C-h>` (Insert), `<C-h/j/k/l>` (Normal), `<C-s>`, and `<leader>ca`.
- [ ] **Deduplicate options** (`lua/core/options.lua`): Remove conflicting 2 vs 4 space indent, duplicate `fillchars`, duplicate `autoread`, and `FoldColumn` highlight reset.
- [ ] **Minor cleanups**:
  - [ ] Fix ignored top-level `timeout_ms` in `lua/configs/conform.lua` (raise `format_on_save.timeout_ms`).
  - [ ] Detect `.venv`/`$VIRTUAL_ENV` instead of hardcoding `/usr/bin/python3` in `lua/plugins/nvim-dap.lua`.
  - [ ] Lazy-load `vim-be-good` on `cmd = "VimBeGood"` (`lua/plugins/vim-be-good.lua`).
  - [ ] Scope VimTeX `conceallevel`/`concealcursor` to `FileType tex` (`lua/plugins/vimtex.lua`).
  - [ ] Delete empty `nvim.log`.

---

## 2. Neovim 0.11 → 0.12 Modernization

*(Currently running Neovim `v0.12.6`)*

- [ ] **Drop manual `lsp/*.lua` loading**: Remove the `dofile()` loop in `lua/plugins/nvim-lspconfig.lua` (Neovim 0.11+/0.12 auto-loads `lsp/<server>.lua` via `vim.lsp.enable()`).
- [ ] **Simplify `lsp/basedpyright.lua`**: Remove static startup `cwd()` `pyproject.toml` regex parsing and rely on basedpyright's native `pyproject.toml` detection.
- [ ] **Use `blink.cmp` LSP capabilities**: Merge `require("blink.cmp").get_lsp_capabilities()` into `vim.lsp.config("*", ...)` (`lua/configs/lspconfig.lua`, `lua/plugins/nvim-lspconfig.lua`).
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

## 3. AI Workflow Setup (Avante + ACP & Inline Completion)

- [ ] **Switch Avante to ACP backends** (`lua/configs/avante.lua`): Replace `provider = "copilot"` with `acp_providers` (`antigravity` via `agy acp` and `opencode` via `opencode acp`; optionally `pi-acp` later), set `mode = "agentic"`, and set `behaviour.auto_suggestions = false`.
- [ ] **Clean Avante config & deps**: Remove deprecated `cursor_applying_provider` and `behaviour.enable_cursor_planning_mode` (`lua/configs/avante.lua`), and trim redundant pickers in `lua/plugins/avante.lua` (keep `telescope.nvim`, drop `mini.pick` and `fzf-lua`).
- [ ] **Rebuild & test Avante ACP**: Run `:Lazy update avante.nvim` / `make`, then verify `:AvanteAsk` and `:AvanteSwitchProvider` with `agy acp` and `opencode acp`.
- [ ] **Decide on `mcphub.nvim`**: Either install `mcp-hub` CLI or remove `lua/plugins/mcphub.lua` and its hooks in `lua/configs/avante.lua`.
- [ ] **Choose inline code completion** (no official Google AI Pro Neovim Tab plugin exists):
  - [ ] Option A: `supermaven-nvim` or `windsurf.nvim` (fast ghost-text, free tier)
  - [ ] Option B: `minuet-ai.nvim` + local Ollama/llama.cpp FIM model (unlimited, GPU-accelerated)
  - [ ] Option C: `minuet-ai.nvim` + Google AI Studio Gemini API key (free tier, rate-limited)
  - [ ] Option D: Keep `copilot.lua` on free tier strictly for inline ghost text (after fixing `<C-j>/<C-k>/<C-l>` keymap collisions)
- [ ] **Optional**: Evaluate lighter ACP/TUI plugins (`agentic.nvim`, `codecompanion.nvim`, or `antigravity.nvim`) if Avante feels too heavy.
