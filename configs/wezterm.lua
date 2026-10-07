---@type Wezterm
local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- Audible bell is tres mal
config.audible_bell = "Disabled"

-- Fonts
config.font = wezterm.font_with_fallback({
	{ family = "FiraCode Nerd Font" },
	{ family = "JetBrains Mono" },
	{ family = "Noto Sans CJK JP" },
	{ family = "Noto Color Emoji" },
})
-- config.command_palette_font = wezterm.font("JetBrains Mono")
-- config.command_palette_font_size = 14

-- The OG:
-- config.color_scheme = 'Tomorrow Night (Gogh)'
-- The current winner(s):
config.color_scheme = "Kanagawa Dragon (Gogh)"
-- config.color_scheme = 'Framer'
-- config.color_scheme = 'DWM rob (terminal.sexy)'

-- Dim inactive panes
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.75 }

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

-- GPU/Renderer: prefer Vulkan on discrete GPU

-- Keybindings
config.leader = { key = "Space", mods = "CTRL|SHIFT" }
config.key_tables = {
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
	},
}
config.keys = {
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},

	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(
				act.PromptInputLine({
					description = "Enter path for new workspace tab",
					action = wezterm.action_callback(function(window, _, line)
						if line and line ~= "" then
							-- Expand ~ if used in path
							local dir = line:gsub("^~", wezterm.home_dir)

							local tab, new_pane, _ = window:mux_window():spawn_tab({ cwd = dir })

							new_pane:split({
								direction = "Top",
								size = 0.75,
								cwd = dir,
								args = { "nvim", dir },
							})
						end
					end),
				}),
				pane
			)
		end),
	},

	-- Tab management
	{
		key = "t",
		mods = "CTRL",
		action = act.ShowLauncherArgs({ flags = "TABS" }),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act.ShowLauncher,
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ShowDebugOverlay,
	},
	{
		key = "!",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			local tab, window = pane:move_to_new_window()
		end),
	},
	{
		key = "n",
		mods = "CTRL|SHIFT",
		action = act.SpawnCommandInNewTab({
			args = {
				"/home/wmcgann/work/tehbilly/wezterm-picker/target/release/wezterm-picker",
				"-c",
				"/usr/bin/nu",
				"-c",
				"/usr/bin/fish",
				"-c",
				"/usr/bin/pwsh",
				"-c",
				"/usr/bin/bash",
				"-c",
				"/usr/bin/zsh",
			},
		}),
	},

	-- Pane management
	{ key = "RightArrow", mods = "CTRL|ALT", action = act.SplitHorizontal },
	{ key = "DownArrow", mods = "CTRL|ALT", action = act.SplitVertical },
	{ key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },

	-- Edit config
	{
		key = ",",
		mods = "CTRL",
		action = act.SpawnCommandInNewTab({ args = { "nvim", wezterm.config_dir } }),
	},
}

-- Setup tabline plugin with OS-specific options
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
	options = {
		icons_enabled = true,
		theme = config.color_scheme or "Tomorrow Night",
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
			{ "cpu" },
			{ "ram" },
		},
		tabline_y = {
			{ "datetime" },
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

wezterm.on("user-var-changed", function(window, pane, name, value)
	-- Ignore the frequent WEZTERM_ user vars, gets spammy
	if name:sub(1, 8) ~= "WEZTERM_" then
		wezterm.log_info("user-var-changed: ", name, "=>", value)
	end

	local env = {
		wezterm = wezterm,
		window = window,
		pane = pane,
		os = os,
		print = print,
		string = string,
		table = table,
		pairs = pairs,
		ipairs = ipairs,
	}

	if name == "run_lua" then
		local func, err = load(value, "shell_lua", "t", env)
		if func then
			local result = func()
			if result ~= nil then
				-- What do heree?
			end
		else
			wezterm.log_error("Failed to parse shell lua command: " .. tostring(err))
		end
	elseif name == "query_lua" then
		local func, err = load(value, "shell_lua", "t", env)
		if func then
			local result = func()
			if result ~= nil then
				pane:send_text(tostring(result) .. "\n")
			else
				pane:send_text("lol")
			end
		end
	end
end)

-- Apply local config if present (wezterm-local.lua next to wezterm.lua)
local local_success, local_config = pcall(require, "wezterm-local")
if local_success and type(local_config) == "table" and type(local_config.apply_to_config) == "function" then
	local_config.apply_to_config(config)
end

return config
