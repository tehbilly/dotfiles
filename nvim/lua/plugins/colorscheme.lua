local colorscheme = require("config.colorscheme")

return {
  colorscheme.plugin,
  dependencies = { "folke/tokyonight.nvim" },
  init = function()
    vim.o.termguicolors = true
    vim.cmd.colorscheme(colorscheme.name)
  end,
}
