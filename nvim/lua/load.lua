local colorscheme = require("colorscheme")

-- Ensure lazy.nvim is available and installed
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

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = {
		colorscheme = { colorscheme.name },
	},
	ui = {
		wrap = false,
		-- Uses same values as: https://neovim.io/doc/user/api.html#nvim_open_win()
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
