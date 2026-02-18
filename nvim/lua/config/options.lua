-- Core editor options
-- Loaded before plugins (from init.lua)

-- Leader keys (must be set before lazy.nvim)
vim.g.mapleader = ","
vim.g.maplocalleader = "'"

-- General
vim.opt.timeout = true
vim.opt.timeoutlen = 400
vim.opt.undofile = true
vim.opt.mouse = "a"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250

-- Search
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Display
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8

-- Tabs & indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Diagnostics
vim.diagnostic.config({
  float = { border = "rounded" },
  virtual_text = { spacing = 4 },
  severity_sort = true,
})
