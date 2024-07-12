local colorscheme = require("colorscheme")

return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "*",
	dependencies = {
		"SmiteshP/nvim-navic",
		colorscheme.plugin,
		"nvim-tree/nvim-web-devicons", -- optional dependency
	},
	opts = {
		theme = colorscheme.name,
	},
}
