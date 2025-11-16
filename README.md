# dotfiles

Bootstrap and manage my dotfiles with chezmoi.

## Quick start

```bash
git clone git@github.com:you/dotfiles.git
cd dotfiles
./setup.sh
```

## What it does

1. Installs mise (user-only) if missing
2. Installs chezmoi (via mise if available)
3. Initializes chezmoi with this repo as source
4. Applies dotfiles (runs pre/post hooks once)
5. Sets zsh as default shell if available

## Host detection

The `run_once_before_10-detect-host.sh` script writes `~/.local/state/chezmoi/host-kind` with values like `omarchy`, `arch`, `fedora`, `debian`, or `unknown`.

Use in templates:

```
{{ $host := (readFile "~/.local/state/chezmoi/host-kind") | trim }}
{{ if eq $host "omarchy" }}
# Omarchy-specific config
{{ end }}
```

## Scripts

- `run_once_before_*` – run before apply, idempotent
- `run_once_after_*` – run after apply, idempotent

## Tools

Tool versions live in `dot_config/mise/config.toml` and are managed by mise.