# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Options I care about
shopt -s nocaseglob
set -o notify # Immediately notify of job termination

# History tweaking
shopt -s histappend
export HISTCONTROL="${HISTCONTROL}${HISTCONTROL+,}ignoreboth"
export PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND+;}history -a"

# Completions
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Make less use lesspipe if available
if command -v lesspipe.sh >/dev/null 2>&1; then
    export LESSOPEN='| /opt/local/bin/lesspipe.sh %s'
fi

# Base16 Shell: https://github.com/chriskempson/base16-shell
# TODO: Make 'er a submodule, or quick way to clone if needed
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-tomorrow-night.sh"
[[ -s "${BASE16_SHELL}" ]] && source "${BASE16_SHELL}"

# Add GOBIN to path if directory exists
if [[ -e "$HOME/go/bin" ]]; then
    export PATH="$HOME/go/bin:$PATH"
fi

# Add cargo to path if directory exists
if [[ -e "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Add ~/.local/bin to path if it exists
if [[ -e "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# If ~/.bashrc.local exists, source it
if [[ -e "$HOME/.bashrc.local" ]]; then
    source "$HOME/.bashrc.local"
fi

# fzf bash integration, if exists
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use GNU tools over default if present
if [[ -e "/opt/local/libexec/gnubin" ]]; then
    export PATH="/opt/local/libexec/gnubin:$PATH"
fi

# Add dotnet global tools to path
if [[ -e "$HOME/.dotnet/tools" ]]; then
    export PATH="$PATH:$HOME/.dotnet/tools"
fi

# Configuration file for ripgrep must be specified in an environment variable
export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgrep/.ripgreprc"

# Add our fancy aliases
[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# If we have pdedupe available, use it to clean up our PATH
# -e excludes paths that are added but don't exist
command -v pdedupe > /dev/null 2>&1 && export PATH=$(pdedupe -e)

# Use starship if available
if command -v starship >/dev/null 2>&1; then
    eval -- "$(starship init bash --print-full-init)"
else
    # PS1 / Promp
    # 256 color code (replace ### with color code): \[\033[38;5;###m\]
    _pbg="\[$(tput setaf 240)\]"
    _pfg="\[$(tput setaf 248)\]"
    _reset="\[$(tput sgr0)\]"
    export PS1="${_pbg}[${_pfg}\u${_pbg}@${_pfg}\H${_pbg} ${_pfg}\w${_pbg}]${_pfg}\\$ ${_reset}"
fi

