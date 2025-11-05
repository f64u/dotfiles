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

  hls = {},
  omnisharp = {
    cmd = { '/Users/fadyadal/.local/share/nvim/mason/bin/omnisharp' },
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

for server, opts in pairs(servers) do
  local base_config = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = servers[server],
    filetypes = (servers[server] or {}).filetypes,
  }

  for opt, value in pairs(opts) do
    ---@diagnostic disable-next-line: assign-type-mismatch
    base_config[opt] = value
  end
  vim.lsp.enable(server)
  vim.lsp.config(server, base_config)
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
