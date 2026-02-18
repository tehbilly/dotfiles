#!/usr/bin/env bash
# Prompt configuration

if command -v starship >/dev/null 2>&1; then
    eval -- "$(starship init bash --print-full-init)"
else
    # Fallback PS1 using 256 colors
    _pbg="\[$(tput setaf 240)\]"
    _pfg="\[$(tput setaf 248)\]"
    _reset="\[$(tput sgr0)\]"
    export PS1="${_pbg}[${_pfg}\u${_pbg}@${_pfg}\H${_pbg} ${_pfg}\w${_pbg}]${_pfg}\\$ ${_reset}"
    unset _pbg _pfg _reset
fi
