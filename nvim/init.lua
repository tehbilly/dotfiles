-- Load core config before plugins
require("config.options")
require("config.keymaps")
require("config.autocmds")

local colorscheme = require("config.colorscheme")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = {
    colorscheme = { colorscheme.name },
  },
  ui = {
    wrap = false,
    border = "rounded",
    title = "lazy.nvim",
  },
  checker = {
    enabled = true,
  },
  profiling = {
    loader = true,
    require = false,
  },
})
