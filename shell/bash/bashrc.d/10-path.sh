#!/usr/bin/env bash
# PATH construction
# Directories are only added if they exist.

[[ -d "$HOME/go/bin" ]]               && export PATH="$HOME/go/bin:$PATH"
[[ -d "$HOME/.cargo/bin" ]]           && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/.local/bin" ]]           && export PATH="$HOME/.local/bin:$PATH"
[[ -d "/opt/local/libexec/gnubin" ]]  && export PATH="/opt/local/libexec/gnubin:$PATH"
[[ -d "$HOME/.dotnet/tools" ]]        && export PATH="$PATH:$HOME/.dotnet/tools"
