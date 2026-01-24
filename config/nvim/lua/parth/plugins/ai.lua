return {
  "olimorris/codecompanion.nvim",
  version = "^18.0.0",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
  },
  opts = {
    interactions = {
      chat = {
        keymaps = {
          send = {
            modes = { n = "<C-s>", i = "<C-s>" },
          },
          close = {
            modes = { n = "<C-x>", i = "<C-x>" },
          },
        },
        adapter = {
          name = "gemini",
          model = "gemini-2.5-flash"
        },
      },
      inline = {
        adapter = {
          name = "gemini",
          model = "gemini-2.5-flash"
        }
      },
      close_on_cancel = false, -- Do not close the chat buffer when pressing Ctrl+c (e.g., with Ctrl-C)
      cmd = {
        adapter = {
          name = "gemini",
          model = "gemini-2.5-flash"
        }
      },
      background = {
        adapter = {
          name = "gemini",
          model = "gemini-2.5-flash"
        }
      },
    },
  },
}
