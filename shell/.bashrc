# shellcheck shell=bash

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Global options
shopt -s nocaseglob # Case-insensitive globbing
shopt -s histappend # Append to history instead of overwriting
shopt -s cdspell    # Auto-correct minor cd typos
shopt -s dirspell   # Auto-correct directory name typos in completion
shopt -s autocd     # Type a directory name to cd into it
set -o notify       # Immediately notify of background job termination

# History
#export HISTCONTROL="${HISTCONTROL}${HISTCONTROL+,}ignoreboth"
#export HISTSIZE=50000
#export HISTFILESIZE=50000
#export HISTTIMEFORMAT="%F %T "
#export PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND+;}history -a"

# Conditional PATH paths: added to PATH if they exist
[[ -d "${HOME}/go/bin" ]] && export PATH="${HOME}/go/bin:$PATH"
[[ -d "${HOME}/.dotnet/tools" ]] && export PATH="${PATH}:$HOME/.dotnet/tools"
[[ -d "${HOME}/.local/bin" ]] && export PATH="${HOME}/.local/bin:$PATH"
[[ -d "/opt/local/libexec/gnubin" ]] && export PATH="/opt/local/libexec/gnubin:$PATH"
[[ -d "${HOME}/.cargo/bin" ]] && export PATH="${HOME}/.cargo/bin:$PATH"

# TODO: Automate setting this up
# Base16 Shell
BASE16_SHELL="${HOME}/.config/base16-shell/scripts/base16-tomorrow-night.sh"
[[ -s "${BASE16_SHELL}" ]] && . "${BASE16_SHELL}"

# Config overrides and app-specific includes
[[ -f "${HOME}/.config/ripgrep/.ripgreprc" ]] && export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgrep/.ripgreprc"
[[ -f "${HOME}/.fzf.bash" ]] && . "${HOME}/.fzf.bash"

# Aliases
[[ -f "${HOME}/.bash_aliases" ]] && . "${HOME}/.bash_aliases"

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

# Machine-specific overrides
[[ -e "${HOME}/.bashrc.local" ]] && . "${HOME}/.bashrc.local"

# Deduplicate PATH entries (-e excludes non-existent paths)
if command -v pdedupe >/dev/null 2>&1; then
    MUNGED="$(pdedupe -e)"
    export PATH="$MUNGED"
fi
