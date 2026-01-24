return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    require("mason-lspconfig").setup {
      ensure_installed = {
        "clangd",
        "lua_ls",
        "rust_analyzer",
        "gradle_ls",
        "gopls",
        "taplo",
      },
    }
  end
}
