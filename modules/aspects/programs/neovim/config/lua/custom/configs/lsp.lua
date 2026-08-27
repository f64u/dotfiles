-- [[ Configure LSP ]]

if vim.g.vscode then
  return
end

local on_attach = require('custom.util.lspconfig').on_attach

-- Every server listed here must be on PATH from the nix package set -- see
-- modules/aspects/programs/neovim/default.nix. mason.nvim is gone, so adding
-- a server means adding its package there too.
local servers = {
  -- clangd = {},
  -- gopls = {},
  nil_ls = {
    settings = {
      ['nil'] = {
        formatting = {
          command = { 'nixfmt' }
        },
        nix = {
          flake = {
            autoArchive = true
          }
        }
      }
    }
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
      analysis = {
        inlayHints = {
          callArgumentNames = false,
        }
      }
    }
  },
  -- Should be managed by rust-tools.nvim:
  -- rust_analyzer = {},
  -- html/cssls/jsonls come from vscode-langservers-extracted.
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  cssls = {},
  jsonls = {},
  ccls = {},
  -- Provided by the opam switch, not nixpkgs -- the zsh aspect's
  -- `eval $(opam env)` is what puts it on PATH.
  ocamllsp = {},
  -- Should be managed by lean.nvim:
  -- leanls = {},
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
            indent_style = 'space',
            indent_size = '2',
            quote_style = 'single',
          }
        }
      },
    },
  },

  millet = {},

  -- REMOVED, all mason-only installs with no nix package behind them:
  --   omnisharp, hls, ts_ls, ansiblels  (mason)
  --   wgsl_analyzer, racket_langserver  (never installed at all)
  -- Re-add one by putting its package in the neovim aspect and listing it
  -- here; `basedpyright`/`ruff` above are the pattern to copy.
}

local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Each entry above is a plain `vim.lsp.config` table, so the shared defaults
-- just get merged underneath it.
for server, opts in pairs(servers) do
  vim.lsp.config(
    server,
    vim.tbl_deep_extend('force', {
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

  -- NOTE: these icons used to be four `vim.fn.sign_define` calls in
  -- plugins/neotree.lua. That API was deprecated for diagnostics in 0.10 and
  -- the legacy path is gone from vim.diagnostic, so with `signs = true` the
  -- gutter fell back to rendering plain "E"/"W"/"I"/"H". Declaring them here
  -- reaches both the gutter and neo-tree, which reads `signs.text`.
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  },

  -- Show the diagnostic float when jumping with the built-in `[d` / `]d`.
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor' })
    end,
  },
})

-- NOTE: the undercurl highlight overrides that used to be here are supplied
-- by catppuccin's native_lsp integration (see plugins/theme.lua), which also
-- survives a later `:colorscheme` -- the raw `:hi` block did not.
