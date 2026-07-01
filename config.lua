-- config.lua - global module definitions
-- This file is machine-agnostic and should be committed to git.
--
-- Modules define what files to manage and how. Available entry types:
--   (default) symlink  - creates a symlink at dst pointing to src
--   copy               - copies the file; tracks changes with hashes
--   template           - renders src as a minijinja template into dst

---@type dotfiles
local df = require("dotfiles")

local config_dir = ".config"
if df.os() == "windows" then
    config_dir = "AppData/Local"
end

local modules = {
    -- Git: rendered from a template so user details can vary per machine
    git = {
        files = {
            { src = "configs/.gitignore.global", dst = ".gitignore" },
            { src = "configs/.gitconfig",        dst = ".gitconfig", type = "template" },
        },
        vars = {
            user_name = "William McGann",
            user_email = "contact@williammcgann.com",
        },
    },

    -- Shell: bash
    bash = {
        files = {
            { src = "shell/.inputrc",         dst = ".inputrc" },
            { src = "shell/.bashrc",          dst = ".bashrc" },
            { src = "shell/posix-aliases.sh", dst = ".bash_aliases" },
        },
    },

    -- Shell: pwsh
    pwsh = {
        files = {
            {
                src = "shell/pwsh/profile.ps1",
                dst = df.path.join(config_dir, "powershell", "Microsoft.PowerShell_profile.ps1"),
            },
        },
    },

    starship = {
        files = {
            { src = "configs/starship.toml", dst = df.path.join(".config", "starship.toml") },
        }
    },

    -- Neovim
    nvim = {
        files = {
            { src = "nvim", dst = df.path.join(config_dir, "nvim") },
        },
    },

    -- Wezterm
    wezterm = {
        files = {
            { src = "configs/wezterm.lua", dst = df.path.join(config_dir, "wezterm", "wezterm.lua") },
        },
    },
}

-- windows: git autocrlf
if df.os() == "windows" then
    modules.git.vars.core_autocrlf = true
end

-- windows: pwsh
if df.os() == "windows" then
    local parent = df.path.join("Documents", "PowerShell")
    local profile = df.path.join(parent, "profile.ps1")

    modules.pwsh.files = {
        { src = "shell/pwsh/profile.ps1", dst = profile },
        { src = "shell/pwsh/profile.d",   dst = df.path.join(parent, "profile.d") },
    }
end

-- windows: wezterm
if df.os() == "windows" then
    modules.wezterm.files = {
        { src = "configs/wezterm.lua", dst = "AppData/Roaming/wezterm/wezterm.lua" },
    }
end

return {
    modules = modules,
    vars = {},
}
