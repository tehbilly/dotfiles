# dotfiles

Personal configuration files for use with [df](https://github.com/tehbilly/df).

## Machine-Specific Files

These files are not tracked and must be created per-machine:

- `~/.gitconfig.local` — GPG program path, signing key, credential helpers
- `~/.gitconfig.work` — Work email/signing key (auto-included for repos under `~/work/`)
- `~/.bashrc.local` — Machine-specific bash overrides (sourced last)
- `profile.local.ps1` — Machine-specific PowerShell overrides
