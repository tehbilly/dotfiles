local wezterm = require("wezterm") --[[@as Wezterm]]
local act = wezterm.action

local config = wezterm.config_builder()
config:set_strict_mode(true)

-- Audible bell is tres mal
config.audible_bell = "Disabled"

-- Default program if another isn't manually specified
config.default_prog = { "pwsh" }

-- Make things a little pretty
-- config.font = wezterm.font("FiraCode Nerd Font")
config.font = wezterm.font_with_fallback({
  {
    family = 'JetBrains Mono',
    -- weight = 'Light',
    -- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
  },
  { family = 'FiraCode Nerd Font' },
  'Noto Color Emoji',
})
config.command_palette_font = wezterm.font("JetBrains Mono") -- Requires nightly
config.command_palette_font_size = 16
config.color_scheme = "Twilight (base16)"

-- Tabs
-- config.use_fancy_tab_bar = true
-- config.tab_bar_at_bottom = false
-- config.hide_tab_bar_if_only_one_tab = true

-- Fancy tabs
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		icons_enabled = true,
		theme = "Tomorrow Night",
		tabs_enabled = true,
		theme_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
		component_separators = {
			left = wezterm.nerdfonts.pl_left_soft_divider,
			right = wezterm.nerdfonts.pl_right_soft_divider,
		},
		tab_separators = {
			left = wezterm.nerdfonts.pl_left_hard_divider,
			right = wezterm.nerdfonts.pl_right_hard_divider,
		},
	},
	sections = {
		tabline_a = {
			{ "mode", icon = wezterm.nerdfonts.oct_arrow_switch },
		},
		tabline_b = {
			{ "workspace", icon = wezterm.nerdfonts.cod_terminal_tmux },
		},
		tabline_c = {},
		tab_active = {
			"index",
			{ "output", padding = { left = 0, right = 1 } },
			{
				"process",
				padding = { left = 0, right = 1 },
				icons_only = false,
			},
			{ "zoomed", padding = 0 },
		},
		tab_inactive = {
			"index",
			{ "output", padding = { left = 0, right = 1 } },
			{
				"process",
				padding = { left = 0, right = 1 },
				icons_only = false,
			},
		},
		tabline_x = {
			{ "cpu", use_pwsh = true },
			{ "ram", use_pwsh = true },
		},
		tabline_y = {
			{
				"datetime",
			},
		},
		tabline_z = {
			{
				"domain",
				domain_to_icon = {
					default = wezterm.nerdfonts.md_monitor,
					ssh = wezterm.nerdfonts.md_ssh,
					wsl = wezterm.nerdfonts.md_microsoft_windows,
					docker = wezterm.nerdfonts.md_docker,
					unix = wezterm.nerdfonts.cod_terminal_linux,
				},
			},
		},
	},
})
tabline.apply_to_config(config)

-- Animation/Renderer
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	local backend_pref = "Vulkan"
	if gpu.backend == backend_pref and gpu.device_type == "DiscreteGpu" then
		config.webgpu_preferred_adapter = gpu
		config.front_end = "WebGpu"
		break
	end
end

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

-- We only SSH to *nix machines, this allows wezterm to do things like spawning tabs in the same directory efficiently
config.ssh_domains = wezterm.default_ssh_domains()
for _, dom in ipairs(config.ssh_domains) do
	dom.assume_shell = "Posix"
end

-- Customize Shortcuts and Hotkeys
config.keys = {
	-- Tab management
	{ -- Spawn a launcher showing the currently open tabs
		key = "t",
		mods = "CTRL",
		action = act.ShowLauncherArgs({ flags = "TABS" }),
	},
	{ -- Show the bog-standard launcher
		key = "l",
		mods = "CTRL",
		action = act.ShowLauncher,
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ShowDebugOverlay,
	},

	-- Pane management
	{ key = "RightArrow", mods = "CTRL|ALT", action = act.SplitHorizontal },
	{ key = "DownArrow", mods = "CTRL|ALT", action = act.SplitVertical },
	{ key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 2 }) },
	{ key = "LeftArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 2 }) },
	{ key = "RightArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 2 }) },
	{ key = "UpArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 2 }) },

	-- Easily edit the config file for wezterm
	{
		key = ",",
		mods = "CTRL",
		action = act.SpawnCommandInNewTab({ args = { "nvim", wezterm.config_dir .. "/wezterm.lua" } }),
	},
}

-- TODO: Add WSL distro icons to the tabline?
-- TODO: Split into OS-specific config files
config.wsl_domains = {
	{
		name = "WSL: Arch",
		distribution = "archlinux",
		default_cwd = "~",
	},
}

-- Maximize window on startup
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
