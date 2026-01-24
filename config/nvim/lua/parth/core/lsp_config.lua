local lsp = vim.lsp
local util = lsp.util

lsp.taplo.setup {}
lsp.lua_ls.setup {}
lsp.denols.setup {}
lsp.dartls.setup {}
lsp.rust_analyzer.setup {}
lsp.clangd.setup {}
lsp.markdown_oxide.setup {}
lsp.gopls.setup {
  root_dir = util.root_pattern('.git'),
  settings = {
    gopls = {
      completeUnimported = true,
    }
  }
}
