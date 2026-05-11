return {
  "williamboman/mason.nvim",
  init = function()
    dofile(vim.g.base46_cache .. "mason")
  end,
  opts = {
    PATH = "skip",
    ui = {
      icons = {
        package_pending = " ",
        package_installed = " ",
        package_uninstalled = " ",
      },
    },
    max_concurrent_installers = 10,
  },
}
