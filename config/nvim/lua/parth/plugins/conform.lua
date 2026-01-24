return {
  'stevearc/conform.nvim',
  opts = {},
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        proto = { "clang_format" },
        -- kdl = { "kdlfmt" },
      },
    })
  end
}
