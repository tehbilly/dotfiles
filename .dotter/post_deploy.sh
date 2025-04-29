#!/usr/bin/env bash

set -euo pipefail

# Install cargo if not present, update otherwise
if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path --profile default -y
    export PATH="${HOME}/.cargo/bin:${PATH}"
else
    # This command can fail if rustup is installed using a package manager
    rustup self update || true
    rustup update
fi

# Install commands managed by cargo
if command -v cargo >/dev/null 2>&1; then
    if ! command -v cargo-install-update >/dev/null 2>&1; then
        cargo install cargo-update
    fi
    if ! command -v dotter >/dev/null 2>&1; then
        cargo install dotter
    fi
    if ! command -v exa >/dev/null 2>&1; then
        cargo install exa
    fi
    if ! command -v fd >/dev/null 2>&1; then
        cargo install fd-find
    fi
    if ! command -v hyperfine >/dev/null 2>&1; then
        cargo install hyperfine
    fi
    if ! command -v lsd >/dev/null 2>&1; then
        cargo install lsd
    fi
    if ! command -v rg >/dev/null 2>&1; then
        cargo install ripgrep
    fi
fi
