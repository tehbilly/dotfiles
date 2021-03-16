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
alias find="find ${@} 2>/dev/null"

# Use aria2c over wget if available
if command -v aria2c >/dev/null 2>&1; then
    alias wget="aria2c"
fi

# Use bat over cat when available
if command -v bat >/dev/null 2>&1; then
    alias cat="bat"
fi

# Directory listing
if command -v exa >/dev/null 2>&1; then
	alias ls="exa"
	alias ll="exa -lag"
else
    alias ll="ls -hal"
fi

# Java version management for MacOS
if [[ "$(uname)" == "Darwin" ]]; then
    export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
    export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
    export JAVA_12_HOME=$(/usr/libexec/java_home -v12)

    alias java8='export JAVA_HOME=$JAVA_8_HOME'
    alias java11='export JAVA_HOME=$JAVA_11_HOME'
    alias java12='export JAVA_HOME=$JAVA_12_HOME'
fi

