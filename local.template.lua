-- This file can be used as a template when bootstrapping a new machine

---@type dotfiles
local df = require("dotfiles")

-- Enabled modules
local modules = {
	"git",
	"nvim",
	"wezterm",
	"starship",
}

-- Default shell setups depending on OS
if df.os() == "windows" then
	table.insert(modules, "pwsh")
else
	table.insert(modules, "bash")
end

local vars = {}

return {
	vars = vars,
	modules = modules,
}
