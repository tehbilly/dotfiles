#!/usr/bin/env bash
# Tool integrations

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-tomorrow-night.sh"
[[ -s "${BASE16_SHELL}" ]] && source "${BASE16_SHELL}"

# zoxide (smarter cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi
