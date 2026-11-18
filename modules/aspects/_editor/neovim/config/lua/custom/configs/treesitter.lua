-- [[ Configure Treesitter ]]
-- nvim-treesitter `main`: parsers are installed explicitly; highlight and
-- indent come from Neovim itself.

-- Under vscode-neovim no plugin is loaded.
if vim.g.vscode then
  return
end

-- Parser names. No `latex`: it keeps vim syntax.
local languages = {
  "c",
  "cpp",
  "go",
  "lua",
  "python",
  "rust",
  "tsx",
  "javascript",
  "typescript",
  "vimdoc",
  "vim",
  -- needed for LSP hover docs, which blink.cmp renders as markdown
  "markdown",
  "markdown_inline",
}

-- Nvim knows help/checkhealth -> vimdoc, but nothing maps tsx -> typescriptreact.
vim.treesitter.language.register("tsx", "typescriptreact")

-- No-op for parsers that are already installed.
require("nvim-treesitter").install(languages)

-- Derive filetypes from the parser list rather than repeating it.
local filetypes = {}
for _, lang in ipairs(languages) do
  vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
  pattern = filetypes,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    -- Must name the syntax; 'on' loads nothing.
    if vim.bo.filetype == "markdown" then
      vim.bo.syntax = "markdown"
    end
  end,
})

-- Incremental selection is built into Nvim 0.12: `an`/`in`, `]n`/`[n`.

-- vim: ts=2 sts=2 sw=2 et
