# Dotfiles TODO

## Cleanup: Remove Dead Code & Cruft

- [x] Remove `vimrc` (legacy Vim config, fully replaced by Neovim)
- [x] Remove `vim_plug` (vendored vim-plug source, only used by `vimrc`)
- [x] Remove `dotter` and `dotter.ps1` (root-level dotter runner scripts)
- [x] Remove `.bin/` directory (bundled dotter binaries)
- [x] Remove `.dotter/` directory (dotter config, templates, hooks, cache)
- [x] Remove `bootstrap.sh` (dotter-specific bootstrap script)
- [x] Remove `nvim/lua/plugins/cmp.lua` (disabled nvim-cmp, never loaded)
- [x] Remove debug `fidget.notify()` call in neo-tree.lua
- [x] Remove duplicate `BufWritePre` autocmd in conform.lua
- [x] Deduplicate fidget.nvim: removed commented-out dependency in lsp.lua, kept standalone fidget.lua
- [x] Remove unused `local Util` import in conform.lua

## Neovim: Popup Borders & Visual Clarity

- [x] Configure LSP hover borders via `LspAttach` autocmd in `config/autocmds.lua`
- [x] Configure LSP signature help borders
- [x] Configure diagnostic float borders in `config/options.lua`
- [x] Add blink.cmp menu, documentation, and signature window borders

## Neovim: LSP Keybindings

- [x] Added via `LspAttach` autocmd in `config/autocmds.lua`:
  - `gd` go to definition, `gD` declaration, `gr` references
  - `gI` implementation, `gy` type definition
  - `K` hover, `<leader>rn` rename, `<leader>ca` code actions
  - `<leader>ds` document symbols, `<leader>ws` workspace symbols
- [x] Added general keybindings in `config/keymaps.lua`:
  - `[d`/`]d` diagnostic navigation, `<leader>e` show diagnostic
  - Window navigation (`C-hjkl`), buffer navigation (`[b`/`]b`)
  - Visual indenting, clear search highlight on Escape

## Neovim: LSP Server Configuration

- [x] Gate `vim.lsp.enable()` on binary availability
- [x] Remove manual `lua_ls` workspace config (lazydev.nvim handles it)
- [x] Add `denols` config
- [x] Add `zls` config

## Neovim: blink.cmp Tuning

- [x] Changed `documentation.auto_show` to `true` with 200ms delay
- [x] Customized enter keymap to only accept when explicitly selected
- [x] Changed `ghost_text.show_with_menu` to `true`

## Neovim: Structure & Organization

- [x] Reorganized into `config/` subdirectory:
  - `config/options.lua` — vim.opt settings
  - `config/keymaps.lua` — non-plugin keybindings
  - `config/autocmds.lua` — autocommands (yank highlight, resize, LSP keymaps/borders)
  - `config/colorscheme.lua` — shared colorscheme definition
- [x] Merged `load.lua` lazy.nvim bootstrap into `init.lua`
- [x] Removed old `opts.lua`, `load.lua`, `colorscheme.lua`
- [x] Updated all plugin files referencing old colorscheme path

## Neovim: Performance & Plugin Audit

- [x] Set `which-key.nvim` to `event = "VeryLazy"`
- [x] Set `conform.nvim` to `event = "BufWritePre"`
- [x] Dropped `Comment.nvim` (Neovim 0.10+ has built-in `gc`)
- [x] Added `event = "VeryLazy"` to telescope, lualine
- [x] Added `event = "LspAttach"` to fidget.nvim
- [x] Added `event = { "BufReadPost", "BufNewFile" }` to treesitter
- [x] Added `gitsigns.nvim` with hunk navigation and staging keybindings
- [x] Added `trouble.nvim` for diagnostics list
- [x] Removed `barbecue.nvim` (and navic dependency), enhanced lualine with relative path display
- [x] Removed redundant `config` function from conform.lua (lazy.nvim handles `opts` natively)
- [x] Added `markdown_inline` to treesitter ensure_installed

## Git Config

- [x] Moved hardcoded `gpg.program` path to `~/.gitconfig.local` (machine-specific)
- [x] Added `[include] path = ~/.gitconfig.local` for machine-specific overrides
- [x] Added `[includeIf "gitdir:~/work/"] path = ~/.gitconfig.work` for work config
  - Note: git silently ignores missing include files, no errors
- [x] Added `[rerere] enabled = true`
- [x] Added `[diff] algorithm = histogram`
- [x] Added `[merge] conflictstyle = zdiff3`
- [x] Added `[fetch] prune = true`
- [x] Added `[pull] rebase = true`
- [x] Removed `panic` alias (tar backup), kept `lc`, `lg`/`lg1`, `diffstat`
- [x] Added aliases: `unstage`, `last`, `amend`, `wip`
- [x] Removed platform-specific credential helper config (moved to local)
- [x] Consistent indentation (spaces, not mixed tabs/spaces)
- [x] Cleaned up .gitignore (removed stale dotter entries)
- [ ] Consider `delta` as a pager — defer until dotfile manager supports conditional templates
- [ ] Keeping GPG signing (yubikey) — no action needed on SSH signing

## Shell Config: Modularize with `bashrc.d/`

- [x] Created slim `bashrc` entrypoint that sources `bashrc.d/*.sh` drop-ins
- [x] Created `bashrc.d/00-options.sh` — shell options + history config
  - Added `cdspell`, `dirspell`, `autocd`
  - Increased `HISTSIZE`/`HISTFILESIZE` to 50000
  - Added `HISTTIMEFORMAT`
- [x] Created `bashrc.d/10-path.sh` — PATH construction
- [x] Created `bashrc.d/20-env.sh` — environment variables
- [x] Created `bashrc.d/30-completions.sh` — bash completions, fzf
- [x] Created `bashrc.d/40-aliases.sh` — absorbed old `bash_aliases` content
- [x] Created `bashrc.d/50-tools.sh` — base16-shell, zoxide
- [x] Created `bashrc.d/90-prompt.sh` — starship with fallback PS1
- [x] Created `bashrc.d/99-cleanup.sh` — PATH deduplication
- [x] Removed old `bash_aliases` file
- [ ] Evaluate mcfly vs current history settings

## Missing Configs

- [x] Added `starship.toml` with language modules for Go, Rust, Lua, Zig, Node
- [x] Added PowerShell profile (`powershell/profile.ps1`) with `profile.d/` drop-in pattern:
  - `00-env.ps1` — environment variables
  - `10-psreadline.ps1` — PSReadLine prediction, history search, tab completion
  - `20-aliases.ps1` — nvim/eza aliases
  - `30-tools.ps1` — zoxide integration
  - `90-prompt.ps1` — starship prompt
- [ ] Add WezTerm config to the repo (already exists elsewhere, needs to be copied in)

## Repo Structure Reorganization

Deferred until the new Lua-based dotfile manager is in place. Current structure
after cleanup:

```
.dotfiles/
├── .gitignore
├── TODO.md
├── bashrc                  # Slim entrypoint
├── bashrc.d/               # Modular bash drop-ins
│   ├── 00-options.sh
│   ├── 10-path.sh
│   ├── 20-env.sh
│   ├── 30-completions.sh
│   ├── 40-aliases.sh
│   ├── 50-tools.sh
│   ├── 90-prompt.sh
│   └── 99-cleanup.sh
├── bat
├── cargo_config
├── gitconfig
├── inputrc
├── nvim/
│   ├── .editorconfig
│   ├── .stylua.toml
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/
│       ├── config/
│       │   ├── autocmds.lua
│       │   ├── colorscheme.lua
│       │   ├── keymaps.lua
│       │   └── options.lua
│       └── plugins/
│           ├── blink.lua
│           ├── colorscheme.lua
│           ├── conform.lua
│           ├── fidget.lua
│           ├── gitsigns.lua
│           ├── lazydev.lua
│           ├── lsp.lua
│           ├── lualine.lua
│           ├── mason.lua
│           ├── neo-tree.lua
│           ├── telescope.lua
│           ├── treesitter.lua
│           ├── trouble.lua
│           └── which-key.lua
├── powershell/
│   ├── profile.ps1
│   └── profile.d/
│       ├── 00-env.ps1
│       ├── 10-psreadline.ps1
│       ├── 20-aliases.ps1
│       ├── 30-tools.ps1
│       └── 90-prompt.ps1
├── ripgrep
├── starship.toml
└── tmux_conf
```

- [ ] Reorganize into grouped directories once dotfile manager supports it
- [ ] Move `bat`, `ripgrep`, `tmux_conf`, `cargo_config`, `inputrc` into appropriate subdirs
