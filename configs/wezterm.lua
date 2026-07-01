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
config.command_palette_font = wezterm.font("JetBrains Mono")
config.command_palette_font_size = 16
config.color_scheme = "Twilight (base16)"

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500

-- GPU/Renderer: prefer Vulkan on discrete GPU
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
    if gpu.backend == "Vulkan" and gpu.device_type == "DiscreteGpu" then
        config.webgpu_preferred_adapter = gpu
        config.front_end = "WebGpu"
        break
    end
end

-- Keybindings
config.keys = {
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

    -- Pane management
    { key = "RightArrow", mods = "CTRL|ALT",  action = act.SplitHorizontal },
    { key = "DownArrow",  mods = "CTRL|ALT",  action = act.SplitVertical },
    { key = "DownArrow",  mods = "ALT",       action = act.ActivatePaneDirection("Down") },
    { key = "LeftArrow",  mods = "ALT",       action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "ALT",       action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow",    mods = "ALT",       action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow",  mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 2 }) },
    { key = "LeftArrow",  mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 2 }) },
    { key = "RightArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 2 }) },
    { key = "UpArrow",    mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 2 }) },

    -- Edit config
    {
        key = ",",
        mods = "CTRL",
        action = act.SpawnCommandInNewTab({ args = { "nvim", wezterm.config_dir .. "/wezterm.lua" } }),
    },
}

-- Maximize window on startup
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

-- TODO: Split config into multiple files, perhaps with os-specific behavior (looking at you, Windows)
-- Setup tabline plugin with OS-specific options
local opts = opts or {}

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

return config
