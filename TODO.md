# Dotfiles TODO

## Cleanup: Remove Dead Code & Cruft

- [ ] Remove `vimrc` (legacy Vim config, fully replaced by Neovim)
- [ ] Remove `vim_plug` (vendored vim-plug source, only used by `vimrc`)
- [ ] Remove `dotter` and `dotter.ps1` (root-level dotter runner scripts)
- [ ] Remove `.bin/` directory (bundled dotter binaries)
- [ ] Remove `.dotter/` directory (dotter config, templates, hooks, cache)
- [ ] Remove `bootstrap.sh` (dotter-specific bootstrap script)
- [ ] Remove `nvim/lua/plugins/cmp.lua` (disabled nvim-cmp, never loaded)
- [ ] Remove debug `fidget.notify()` call in `nvim/lua/plugins/neo-tree.lua:32-33`
- [ ] Remove duplicate `BufWritePre` autocmd in `nvim/lua/plugins/conform.lua:42-51` (the `format_on_save` option already handles this)
- [ ] Deduplicate fidget.nvim: remove commented-out dependency in `lsp.lua:4-5`, keep standalone `fidget.lua`

## Neovim: Popup Borders & Visual Clarity

Hover windows and informational popups lack borders, making them hard to
distinguish from the editor background.

- [ ] Configure LSP hover borders:
  ```lua
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  ```
- [ ] Configure diagnostic float borders:
  ```lua
  vim.diagnostic.config({ float = { border = "rounded" } })
  ```
- [ ] Add blink.cmp window borders:
  ```lua
  completion = {
    menu = { border = "rounded" },
    documentation = { window = { border = "rounded" } },
  }
  ```

## Neovim: LSP Keybindings

There are currently no LSP keybindings defined anywhere. Add via `LspAttach` autocmd:

- [ ] `gd` — go to definition
- [ ] `gr` — references
- [ ] `K` — hover documentation
- [ ] `<leader>rn` — rename symbol
- [ ] `<leader>ca` — code actions
- [ ] `<leader>ds` — document symbols
- [ ] `[d` / `]d` — previous/next diagnostic

## Neovim: LSP Server Configuration

- [ ] Gate `vim.lsp.enable()` on binary availability to avoid errors on machines missing specific language servers
- [ ] Remove manual `lua_ls` workspace config in `lsp.lua` — lazydev.nvim already handles Neovim runtime library injection
- [ ] Add `denols` or `ts_ls` config (deno is in Mason but has no LSP config)
- [ ] Add `zls` config (zig is in treesitter `ensure_installed` but has no LSP)

## Neovim: blink.cmp Tuning

- [ ] Change `documentation.auto_show` to provide documentation automatically after 200ms delay
- [ ] Evaluate `"enter"` keymap preset — pressing Enter to create a newline can accidentally accept completions. Customize enter to only accept when explicitly selected
- [ ] Review `ghost_text.show_with_menu = false` — decide if ghost text should also show when the menu is visible

## Neovim: Structure & Organization

- [ ] Consider reorganizing `nvim/lua/` into:
  ```
  nvim/lua/
  ├── config/
  │   ├── options.lua      # vim.opt settings (currently opts.lua)
  │   ├── keymaps.lua      # Non-plugin keybindings (currently scattered)
  │   ├── autocmds.lua     # Autocommands (currently inline in plugins)
  │   └── colorscheme.lua  # Shared colorscheme definition
  └── plugins/             # Plugin specs (cleaned up)
  ```
- [ ] Merge `load.lua` lazy.nvim bootstrap into `init.lua`
- [ ] Extract keybindings from individual plugin configs into a central location for easier overview and conflict detection
  - If possible, still separate by plugin and see if we can only define keybindings for plugins that are available/loaded

## Neovim: Performance & Plugin Audit

- [ ] Set `which-key.nvim` to lazy-load (currently `lazy = false`)
- [ ] Set `conform.nvim` to load on `BufWritePre` event instead of `lazy = false`
- [ ] Drop `Comment.nvim` — Neovim 0.10+ has built-in `gc` commenting
- [ ] Add `event = "VeryLazy"` or appropriate `ft`/`event` triggers to plugins that don't need immediate startup loading
- [ ] Add `gitsigns.nvim` for git gutter signs, inline blame, hunk staging
- [ ] Add `trouble.nvim` for a better diagnostics list
- [ ] Switch from `barbecue.nvim` to lualine

## Git Config

### General changes

- [ ] Ensure no outdated advice or settings (see: crlf handling, ensure following current best practices)

### Conditional Includes & Platform Independence

- [ ] Move hardcoded `gpg.program` path out of shared gitconfig into a machine-local include file (`~/.gitconfig.local`, gitignored)
- [ ] Add conditional includes for work vs personal (will these cause errors if the included path doesn't exist?):
  ```ini
  [include]
      path = ~/.gitconfig.local

  [includeIf "gitdir:~/work/"]
      path = ~/.gitconfig.work
  ```
- [ ] Consider switching from GPG to SSH signing (simpler cross-platform setup, GitHub/GitLab support it natively)
  - Currently using a yubikey for signing, I prefer GPG

### Missing Useful Settings

- [ ] `[rerere] enabled = true` — remember resolved merge conflicts
- [ ] `[diff] algorithm = histogram` — better diff output
- [ ] `[merge] conflictstyle = zdiff3` — show base version in conflict markers
- [ ] `[fetch] prune = true` — auto-prune stale remote-tracking branches
- [ ] `[pull] rebase = true` — if rebase workflow is preferred
- [ ] Consider `delta` as a pager (`[core] pager = delta`) for improved diffs
  - Can this be done only if delta is available? New dotfile management tool will have the ability to process source files as templates with conditionals

### Aliases

- [ ] Review/update existing aliases (`panic`, `lc`, `diffstat` — still used?)
- [ ] Consider adding:
  - `unstage = reset HEAD --`
  - `last = log -1 HEAD`
  - `amend = commit --amend --no-edit`
  - `wip = !git add -A && git commit -m 'WIP'`

## Shell Config: Modularize with `bashrc.d/`

The current `bashrc` is a single monolithic file mixing PATH setup, options,
completions, prompt config, and tool integrations. Adopt a `bashrc.d/` drop-in
directory pattern for modular configuration.

### Proposed structure

```
bashrc                # Slim entrypoint: set core options, then source bashrc.d/*.sh, then source ~/.bashrc.local if present
bashrc.d/
├── 00-options.sh     # Shell options (nocaseglob, histappend, notify, etc.)
├── 10-path.sh        # PATH construction (go, cargo, local/bin, dotnet, gnubin)
├── 20-env.sh         # Environment variables (RIPGREP_CONFIG_PATH, LESSOPEN, etc.)
├── 30-completions.sh # Bash completions, fzf integration
├── 40-aliases.sh     # Aliases (absorb current bash_aliases content)
├── 50-tools.sh       # Tool integrations (base16-shell, zoxide, etc.)
├── 90-prompt.sh      # Starship init with fallback PS1
├── 99-cleanup.sh     # PATH deduplication (pdedupe), final housekeeping
```

### Design notes

- Files are sourced in lexicographic order — numeric prefixes control load order
- Each file is a self-contained concern, easy to enable/disable by renaming
- `bashrc.local` sourcing is preserved for machine-specific overrides
- The `bash_aliases` file content moves into `bashrc.d/40-aliases.sh` (one less separate file to track)

### bashrc entrypoint

The new `bashrc` becomes minimal:
```bash
# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# Source all bashrc.d drop-ins in order
for f in ~/.bashrc.d/*.sh; do
    [[ -r "$f" ]] && source "$f"
done
unset f

# Machine-specific overrides
[[ -e "$HOME/.bashrc.local" ]] && source "$HOME/.bashrc.local"
```

### Missing shell features to add

- [ ] `shopt -s cdspell` — auto-correct minor `cd` typos
- [ ] `shopt -s dirspell` — auto-correct directory names during tab completion
- [ ] `shopt -s autocd` — type a directory name to `cd` into it
- If _not_ using mcfly for history:
  - [ ] Increase history size: `HISTSIZE=50000`, `HISTFILESIZE=50000`
  - [ ] Add `HISTTIMEFORMAT="%F %T "` for timestamped history
- If using mcfly for history:
  - [ ] Evaluate proper opts based on current settings
- If zoxide is present and available:
  - [ ] Add `zoxide` integration (`eval "$(zoxide init bash)"`)

## Missing Configs to Add

- [ ] Add WezTerm config to the repo (already exists, just needs tracking)
- [ ] Add a `starship.toml` config (currently using starship with no tracked config)
- [ ] Add a PowerShell profile (`profile.ps1`) with similar goals to bashrc changes above. Slim entrypoint with inclusion dir and ability to do local overrides.
- [ ] Add following to inclusion dir:
  - Starship prompt init
  - PSReadLine config (prediction, history search)
  - Key aliases/functions
  - Environment variables

## Repo Structure Reorganization

Once the new dotfile manager is in place, consider reorganizing from the current
flat layout into grouped directories:

```
.dotfiles/
├── config.lua              # Dotfile manager configuration
├── git/
│   ├── gitconfig
│   └── gitconfig.personal
├── shell/
│   ├── bashrc
│   ├── bashrc.d/
│   │   └── *.sh
│   ├── inputrc
│   └── starship.toml
├── nvim/                   # Keep as-is (cohesive unit)
├── wezterm.lua
├── powershell/
│   ├── profile.ps1
│   ├── profile.d/
│   │   └── *.ps1
├── tools/
│   ├── bat
│   ├── ripgrep
│   └── tmux.conf
└── cargo/
    └── config.toml
```
