#!/usr/bin/env bash

# nvim > vim
if command -v nvim >/dev/null 2>&1; then
    alias vim="nvim"
fi

# grep aliases
if command -v rg >/dev/null 2>&1; then
    alias grep="rg"
else
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

# This stops find from flooding stderr for permission issues
if command -v fd >/dev/null 2>&1; then
    alias find="fd --hidden --no-ignore --follow --exclude .git"
else
    # Use find with error suppression for permission issues
    alias find="find ${@} 2>/dev/null"
fi

# Use aria2c over wget if available
if command -v aria2c >/dev/null 2>&1; then
    alias wget="aria2c"
fi

# Directory listing
if command -v eza >/dev/null 2>&1; then
	alias ls="eza"
	alias ll="eza -lagh"
elif command -v lsd >/dev/null 2>&1; then
    alias ls="lsd"
    alias ll="lsd -hal"
else
    alias ll="ls -hal"
fi
