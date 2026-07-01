-- local.lua — machine-specific configuration
-- Do not commit this file (it is listed in .gitignore).
--
-- Activate modules for this machine and override variables as needed.
-- The dotfiles global provides helpers for conditional configuration:
--
--   dotfiles.os()                            -> "linux", "macos", "windows", …
--   dotfiles.hostname()                      -> machine hostname
--   dotfiles.which("nvim")                   -> path to binary, or nil
--   dotfiles.env("VAR")                      -> env var value, or nil
--   dotfiles.env("VAR", "default_if_unset")  -> env var value, or default_if_unset

local modules = {
    "git",
    "nvim",
    "wezterm",
    "starship",
    -- "pwsh",
    -- "bash",
}
local vars = {}

return {
    vars = vars,
    modules = modules,
}
