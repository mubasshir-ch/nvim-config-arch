local M = {
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.

    vim.g.vimtex_view_method = "zathura"
    -- vim.g.vimtex_view_general_viewer = "/home/mub/.local/bin/SumatraPDF.sh"
    -- vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
    vim.g.tex_conceal = "abdmg"
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      ligatures = 1,
      cites = 1,
      fancy = 1,
      spacing = 1,
      greek = 1,
      math_bounds = 1,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      sections = 1,
      styles = 1,
    }
    vim.opt.conceallevel = 2
    vim.opt.concealcursor = "nc"

    vim.g.vimtex_compiler_latexmk = {
      aux_dir = "aux", -- create a directory called aux that will contain all the auxiliary files
      out_dir = "build", -- create a directory called build that will contain all the build files
      -- continuous = 1, -- run the compiler in continuous module
      -- callback = 1, -- run the compiler in callback mode
    }
    vim.g.vimtex_quickfix_ignore_filters = {
      "Underfull",
    }
    -- vim.g.vimtex_quickfix_open_on_warning = 1
  end,
}

return M
