return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { 'nvim-lua/plenary.nvim',
    {
      "nvim-telescope/telescope-fzf-native.nvim", build = "make"
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-CR>"] = actions.select_vertical,
            ["<A-CR>"] = actions.select_horizontal,
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
          },
        },
      },
    })
    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
  end,
}
