# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Global options
setopt NO_CASE_GLOB      # Case-insensitive globbing
setopt APPEND_HISTORY    # Append to history instead of overwriting
setopt AUTO_CD           # Type a directory name to cd into it
setopt NOTIFY            # Immediately notify of background job termination
setopt CORRECT           # Auto-correct minor command typos
setopt EXTENDED_GLOB     # Extended pattern matching
setopt SHARE_HISTORY     # Share history across sessions
setopt HIST_IGNORE_DUPS  # Don't record duplicate history entries

# History (fallback if atuin not found)
if ! command -v atuin >/dev/null 2>&1; then
    HISTFILE=~/.zsh_history
    HISTSIZE=50000
    SAVEHIST=50000
    setopt EXTENDED_HISTORY  # Record timestamp in history
fi

# Zsh completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Conditional PATH paths: added to PATH if they exist
[[ -d "${HOME}/go/bin" ]] && export PATH="${HOME}/go/bin:$PATH"
[[ -d "${HOME}/.dotnet/tools" ]] && export PATH="${PATH}:$HOME/.dotnet/tools"
[[ -d "${HOME}/.local/bin" ]] && export PATH="${HOME}/.local/bin:$PATH"
[[ -d "/opt/local/libexec/gnubin" ]] && export PATH="/opt/local/libexec/gnubin:$PATH"
[[ -d "${HOME}/.cargo/bin" ]] && export PATH="${HOME}/.cargo/bin:$PATH"

# Environment variables
export EDITOR="nvim"
[[ -f "${HOME}/.config/ripgrep/.ripgreprc" ]] && export RIPGREP_CONFIG_PATH="${HOME}/.config/ripgrep/.ripgreprc"

# Zsh plugins (system-installed)
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Aliases
[[ -f "${HOME}/.dotfiles/shell/posix-aliases.sh" ]] && . "${HOME}/.dotfiles/shell/posix-aliases.sh"

# Prompt configuration
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    # Fallback prompt using 256 colors
    PROMPT='%F{240}[%F{248}%n%F{240}@%F{248}%M%F{240} %F{248}%~%F{240}]%F{248}%# %f'
fi

# Keybindings (ctrl-left/right word navigation)
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Machine-specific overrides (MUST be last)
[[ -f "${HOME}/.zshrc.local" ]] && . "${HOME}/.zshrc.local"
