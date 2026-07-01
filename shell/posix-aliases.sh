# shellcheck shell=bash

# Aliases — prefer modern CLI tools with graceful fallbacks

# nvim > vim
if command -v nvim >/dev/null 2>&1; then
    alias vim="nvim"
fi

# ripgrep > grep
if command -v rg >/dev/null 2>&1; then
    alias grep="rg"
else
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

# fd > find
if command -v fd >/dev/null 2>&1; then
    alias find="fd --hidden --no-ignore --follow --exclude .git"
else
    alias find="find 2>/dev/null"
fi

# aria2c > wget
if command -v aria2c >/dev/null 2>&1; then
    alias wget="aria2c"
fi

# Directory listing: eza > lsd > ls
if command -v eza >/dev/null 2>&1; then
    alias ls="eza"
    alias ll="eza -lagh"
elif command -v lsd >/dev/null 2>&1; then
    alias ls="lsd"
    alias ll="lsd -hal"
else
    alias ll="ls -hal"
fi

# zoxide (smarter cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi
