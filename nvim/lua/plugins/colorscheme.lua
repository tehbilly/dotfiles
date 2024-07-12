local colorscheme = require("colorscheme")

return {
  colorscheme.plugin,
  init = function()
    vim.cmd.colorscheme(colorscheme.name)
  end,
}
