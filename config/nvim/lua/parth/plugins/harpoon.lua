return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
      vim.cmd('echo "Added buffer to harpoon"')
    end)
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<C-1>", function()
      harpoon:list():select(1)
      vim.cmd('echo "At buffer 1"')
    end)

    vim.keymap.set("n", "<C-2>", function()
      harpoon:list():select(2)
      vim.cmd('echo "At buffer 2"')
    end)

    vim.keymap.set("n", "<C-3>", function()
      harpoon:list():select(3)
      vim.cmd('echo "At buffer 3"')
    end)

    vim.keymap.set("n", "<C-4>", function()
      harpoon:list():select(4)
      vim.cmd('echo "At buffer 4"')
    end)

    vim.keymap.set("n", "<C-5>", function()
      harpoon:list():select(5)
      vim.cmd('echo "At buffer 5"')
    end)

    vim.keymap.set("n", "<C-M-n>", function()
      harpoon:list():next()
    end)

    vim.keymap.set("n", "<C-M-p>", function()
      harpoon:list():prev()
    end)
  end
}
