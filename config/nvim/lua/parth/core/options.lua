-- OPTS
local opt = vim.opt

-- line numbering and stuff
opt.relativenumber = true
opt.number = true
opt.scrolloff = 8

-- tabs and indentations
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.autoindent = true
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- color and themeing
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- splitting windows
opt.splitright = true
opt.splitbelow = true

opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.fillchars = { eob = ' ' }

-- line length
opt.textwidth = 0

-- DIAGNOSTICS
local diagnostic = vim.diagnostic
diagnostic.config({
  virtual_text = true,
  update_in_insert = true,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "/home/parth/obsidian/*",
  callback = function()
    vim.opt.conceallevel = 2
  end,
})
