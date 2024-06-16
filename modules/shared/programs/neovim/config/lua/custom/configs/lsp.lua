-- [[ Configure LSP ]]

local on_attach = require('custom.util.lspconfig').on_attach

local servers = {
  -- clangd = {},
  -- gopls = {},
  nil_ls = {
    settings = {
      ['nil'] = {
        formatting = {
          command = { 'nixpkgs-fmt' }
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
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          ruff = {
            enabled = true,
            extendSelect = { 'I' }
          },
          mypy = {
            enabled = true
          },
          yapf = {
            enabled = true
          },
        },
        configurationSources = { 'mypy', 'ruff', 'yapf' }
      }
    }
  },
  -- Should be managed by rust-tools.nvim:
  -- rust_analyzer = {},
  tsserver = {},
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

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


for server, opts in pairs(servers) do
  local base_config = {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = servers[server],
    filetypes = (servers[server] or {}).filetypes,
  }

  for opt, value in pairs(opts) do
    base_config[opt] = value
  end
  require('lspconfig')[server].setup(base_config)
end
