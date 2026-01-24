vim.g.mapleader = " "
local keymap = vim.keymap

-- tab creation and traversal
keymap.set("n", "<leader>th", "<cmd>tabp<CR>", { desc = "Go to the tab on the left of the current tab" })
keymap.set("n", "<leader>tl", "<cmd>tabn<CR>", { desc = "Go to the tab on the right of the current tab" })
keymap.set("n", "<leader>tn", ":Texplore<CR>", { desc = "Make a new tab" })
keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close current tab" })

-- split creation and traversal
---- deleting orignal keymap
---- setting new keymaps
keymap.set("n", "<M-h>", "<cmd>wincmd h<CR>", { noremap = true, silent = true, desc = "Go to the pane on the left" })
keymap.set("n", "<M-j>", "<cmd>wincmd j<CR>", { noremap = true, silent = true, desc = "Go to the pane on the down" })
keymap.set("n", "<M-k>", "<cmd>wincmd k<CR>", { noremap = true, silent = true, desc = "Go to the pane on the up" })
keymap.set("n", "<M-l>", "<cmd>wincmd l<CR>", { noremap = true, silent = true, desc = "Go to the pane on the right" })

keymap.set("n", "<C-A-h>", "<cmd>vertical resize -2<CR>", { silent = true, desc = "Decrease pane width" })
keymap.set("n", "<C-A-l>", "<cmd>vertical resize +2<CR>", { silent = true, desc = "Increase pane width" })
keymap.set("n", "<C-A-j>", "<cmd>resize -2<CR>", { silent = true, desc = "Decrease pane height" })
keymap.set("n", "<C-A-k>", "<cmd>resize +2<CR>", { silent = true, desc = "Increase pane height" })

keymap.set("n", "<C-A-r>", "<cmd>vsplit<CR>", { silent = true, desc = "Vertical split" })
keymap.set("n", "<C-A-d>", "<cmd>split<CR>", { silent = true, desc = "Horizontal split" })


-- misc
keymap.set("n", "<leader>cs", ":nohl<CR>", { desc = "Clear Search Highlights" })

-- commenting lines
vim.api.nvim_set_keymap('n', '<C-/>', 'gcc', { noremap = false, silent = false }) -- Toggle comment for current line
vim.api.nvim_set_keymap('v', '<C-/>', "gc", { noremap = false, silent = false })  -- Toggle comment for selected lines

-- which key
keymap.set("n", "<leader>ww", "<cmd>WhichKey<cr>", { desc = "Show available keymaps" })

-- git stuff
keymap.set("n", "<leader>gp", "<cmd>:Gitsigns preview_hunk<cr>", { desc = "Preview Git Changes" })
keymap.set("n", "<leader>grr", "<cmd>:Gitsigns reset_hunk<cr>", { desc = "Reset Change" })
keymap.set("n", "<leader>gt", "<cmd>:Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle Line Blame" })

-- telescopy
keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
keymap.set("n", "<leader>tr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
keymap.set("n", "<leader>ts", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
keymap.set("n", "<leader>tf", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

-- files
keymap.set("n", "<leader>ee", ":Ex<CR>", { desc = "Switch to NetRW" })

-- LSP
keymap.set("n", "<leader>lf", function() vim.lsp.buf.definition() end, { desc = "LSP definition" })
keymap.set("n", "<leader>lh", function() vim.lsp.buf.hover({ border = "double" }) end, { desc = "LSP hover" })
keymap.set("n", "<leader>lws", function() vim.lsp.buf.workspace_symbol() end, { desc = "LSP workspace symbol" })
keymap.set("n", "<leader>.", function() vim.lsp.buf.code_action() end, { desc = "Show LSP powered code actions" })
keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, {})
keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, { desc = "Rename" })
keymap.set("n", "<leader>li", function() vim.lsp.buf.implementation() end, { desc = "Go To implementation" })
keymap.set("n", "<leader>ii", function() require("conform").format({ async = false, lsp_fallback = true }) end,
  { desc = "Format using Formatter or LSP" })
keymap.set("n", "<leader>ll", function() vim.lsp.buf.signature_help({ border = "double" }) end,
  { desc = "Signature Help" })
keymap.set("n", "<leader>er", function() vim.diagnostic.open_float({ border = "double" }) end,
  { desc = "Show the error message" })

-- csv
keymap.set("n", "<leader>cv", "<cmd>CsvViewToggle delimiter=, quote_char=' comment=# display_mode=border <CR>",
  { desc = 'Toggle csv view' })

-- ai
keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle AI chat window." })
