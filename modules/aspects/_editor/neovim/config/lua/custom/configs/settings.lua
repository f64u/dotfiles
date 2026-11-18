vim.g.have_nerd_font = true

-- Set highlight on search
vim.opt.hlsearch = false

-- Make line numbers default
vim.opt.number = true

-- Make it relative line numbers
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Share the OS clipboard.
vim.opt.clipboard = "unnamedplus"

-- Highlights active cursor line
vim.opt.cursorline = true

-- Enable break indent
vim.opt.breakindent = true

-- Primagean inspired [copied] undo stuff {{{
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.opt.undofile = true
vim.opt.scrolloff = 8
-- }}}

-- `zg`/`zw` write here; ~/.config/nvim/spell is a read-only store link.
vim.opt.spellfile = vim.fn.stdpath("state") .. "/spell/en.utf-8.add"

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "menuone", "noinsert" }

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- disable nvim intro
vim.opt.shortmess:append("sI")

-- Treesitter folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99

-- always show tabline
-- vim.optpt.showtabline = 2

local fady_group = vim.api.nvim_create_augroup("FadyGroup", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
  group = fady_group,
  pattern = "*",
})

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show some whitespace characters.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
