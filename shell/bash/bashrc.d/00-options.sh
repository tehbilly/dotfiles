#!/usr/bin/env bash
# Shell options

shopt -s nocaseglob   # Case-insensitive globbing
shopt -s histappend   # Append to history instead of overwriting
shopt -s cdspell      # Auto-correct minor cd typos
shopt -s dirspell     # Auto-correct directory name typos in completion
shopt -s autocd       # Type a directory name to cd into it

set -o notify         # Immediately notify of background job termination

# History
export HISTCONTROL="${HISTCONTROL}${HISTCONTROL+,}ignoreboth"
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTTIMEFORMAT="%F %T "
export PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND+;}history -a"
