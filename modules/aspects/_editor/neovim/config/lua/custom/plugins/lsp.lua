return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Servers come from nix (../../../default.nix), not mason.

    -- Useful status updates for LSP
    { "j-hui/fidget.nvim", opts = {}, event = "LspAttach" },

    -- Lua LS support for the Neovim API. Replaces neodev.nvim, archived 2024-07.
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },

    { "saghen/blink.cmp" },
  },
}
