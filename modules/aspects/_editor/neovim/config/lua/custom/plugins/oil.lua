-- File browser: a directory is a buffer you edit. Replaces neo-tree.
return {
  "stevearc/oil.nvim",
  lazy = false, -- takes over directory buffers (`nvim .`) from netrw
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    view_options = { show_hidden = true },
    float = { max_width = 0.6, max_height = 0.7 },
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open the parent directory" },
    { "\\", "<cmd>Oil<cr>", desc = "Reveal the file in its directory" },
    {
      "<C-n>",
      function()
        require("oil").toggle_float()
      end,
      desc = "Toggle the file browser",
    },
  },
}
