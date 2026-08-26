-- [[ Configure LSP ]]

if vim.g.vscode then
  return
end

local on_attach = require('custom.util.lspconfig').on_attach

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
  ts_ls = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  cssls = {},
  ccls = {},
  ocamllsp = {},
  -- Should be managed by lean.nvim:
  -- leanls = {},
  taplo = {},
  jsonls = {},
  wgsl_analyzer = {},
  racket_langserver = {},
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

  hls = {},
  omnisharp = {
    -- was hardcoded to /Users/fadyadal/..., which cannot exist on nixos-desktop
    cmd = { vim.fn.stdpath 'data' .. '/mason/bin/omnisharp' },
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
  },

  millet = {},
  ansiblels = {}
}

-- For wgsl to work
vim.filetype.add({
  extension = { wgsl = 'wgsl' }
})

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
  signs = true,
  virtual_text = false,
  severity_sort = true,
})

-- Set diagnostic highlights to use undercurl
vim.cmd([[
  hi DiagnosticUnderlineError cterm=undercurl gui=undercurl
  hi DiagnosticUnderlineWarn cterm=undercurl gui=undercurl
  hi DiagnosticUnderlineInfo cterm=undercurl gui=undercurl
  hi DiagnosticUnderlineHint cterm=undercurl gui=undercurl
]])
