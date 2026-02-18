#!/usr/bin/env bash
# Environment variables

export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgrep/.ripgreprc"

# Use lesspipe if available
if command -v lesspipe.sh >/dev/null 2>&1; then
    export LESSOPEN='| /opt/local/bin/lesspipe.sh %s'
fi
