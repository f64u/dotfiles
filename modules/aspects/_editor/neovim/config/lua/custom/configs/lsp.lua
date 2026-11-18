-- [[ Configure LSP ]]

if vim.g.vscode then
  return
end

local on_attach = require("custom.util.lspconfig").on_attach

-- Each server must be on PATH from nix: add its package in
-- modules/aspects/_editor/neovim/default.nix too.
local servers = {
  -- clangd = {},
  -- gopls = {},
  nixd = {
    settings = {
      nixd = {
        formatting = {
          command = { "nixfmt" },
        },
      },
    },
  },
  bashls = {},
  -- pylsp = {
  --   settings = {
  --     pylsp = {
  --       plugins = {
  --         ruff = {
  --           enabled = true,
  --           extendSelect = { 'I' }
  --         },
  --         mypy = {
  --           enabled = true
  --         },
  --       },
  --       configurationSources = { 'mypy', 'ruff' }
  --     }
  --   }
  -- },
  ruff = {},
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          inlayHints = {
            callArgumentNames = false,
          },
        },
      },
    },
  },
  -- rust_analyzer is managed by rust-tools.nvim.
  -- html/cssls/jsonls come from vscode-langservers-extracted.
  html = { filetypes = { "html", "twig", "hbs" } },
  cssls = {},
  jsonls = {},
  clangd = {},
  -- From the opam switch, not nixpkgs.
  ocamllsp = {},
  -- leanls is managed by lean.nvim.
  taplo = {},
  texlab = {},
  tinymist = {},

  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            quote_style = "single",
          },
        },
      },
    },
  },

  millet = {},
}

local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Merge the shared defaults under each entry.
for server, opts in pairs(servers) do
  vim.lsp.config(
    server,
    vim.tbl_deep_extend("force", {
      capabilities = capabilities,
      on_attach = on_attach,
    }, opts)
  )
  vim.lsp.enable(server)
end

vim.lsp.inlay_hint.enable(true)

vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
  underline = true,
  virtual_text = false,
  severity_sort = true,

  -- Declared here: `vim.fn.sign_define` no longer reaches diagnostics.
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },

  -- Show the diagnostic float when jumping with the built-in `[d` / `]d`.
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor" })
    end,
  },
})
