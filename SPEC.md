0. Repo Structure (create exactly this)
dotfiles/
├── setup.sh
├── chezmoi.toml.tmpl
├── dot_config/
│   ├── mise/
│   │   └── config.toml
│   ├── shell/
│   │   ├── omarchy.sh.tmpl
│   │   ├── linux.sh.tmpl
│   │   └── macos.sh.tmpl
│   └── zsh/
│       └── .zshrc.tmpl
├── run_once_before_10-detect-host.sh
├── run_once_before_20-install-mise.sh
├── run_once_before_30-install-chezmoi.sh
├── run_once_after_10-set-shell.sh
└── run_after_40-install-tools.sh


Notes:

run_once_before_* runs before apply (only first time).
run_once_after_*  runs after apply (only first time).
run_after_*       runs after apply (every time).
All run_* are idempotent.

1. setup.sh (top-level bootstrap script)

Create this at repo root.

#!/usr/bin/env bash
set -euo pipefail

REPO_SOURCE="$PWD"
CHEZMOI_VERSION="2.67.0"                           # bump to upgrade chezmoi
export PATH="$HOME/.local/bin:$PATH"

INSTALLED=""                                       # track what we install

# Ensure mise
ensure_mise() {
    if command -v mise >/dev/null 2>&1; then
        return
    fi
    echo "[bootstrap] Installing mise (user)"
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    INSTALLED="${INSTALLED}mise "
}

# Ensure chezmoi
ensure_chezmoi() {
    if command -v chezmoi >/dev/null 2>&1; then
        return
    fi
    if command -v mise >/dev/null 2>&1; then
        echo "[bootstrap] Installing chezmoi via mise"
        mise install chezmoi
        mise use -g chezmoi@"$CHEZMOI_VERSION"
        INSTALLED="${INSTALLED}chezmoi "
        return
    fi
    echo "[bootstrap] Installing chezmoi via script"
    sh -c "$(curl -fsLS get.chezmoi.io)"
    export PATH="$HOME/.local/bin:$PATH"
    INSTALLED="${INSTALLED}chezmoi "
}

# Init / apply
chezmoi_init_apply() {
    export PATH="$HOME/.local/bin:$PATH"
    hash -r 2>/dev/null || true

    echo "[bootstrap] Initializing chezmoi"
    mise x chezmoi -- chezmoi init --source "$REPO_SOURCE"

    echo "[bootstrap] Applying"
    if ! mise x chezmoi -- chezmoi apply; then
        echo "[bootstrap] chezmoi apply failed (non-critical)"
    fi

    # Summary
    if [ -n "$INSTALLED" ]; then
        echo "[bootstrap] Done (installed: $INSTALLED)"
    else
        echo "[bootstrap] Done (no new installs)"
    fi
}

ensure_mise
ensure_chezmoi
chezmoi_init_apply


Idempotent:

init only runs once.

apply runs each time.

2. chezmoi.toml.tmpl (global config + host detection wiring)

Create at repo root.

[data]
  hostname = "{{ .chezmoi.hostname }}"
  os = "{{ .chezmoi.os }}"
  kernel = "{{ (output "uname" "-s") | trim }}"
  distro = "{{ (output "sh" "-c" "source /etc/os-release 2>/dev/null; echo ${ID:-unknown}") | trim }}"


This gives .data.os, .data.distro, .data.kernel.

3. Strong host detection script

Creates a persistent fact: ~/.local/state/chezmoi/host-kind.

Create: run_once_before_10-detect-host.sh

#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.local/state/chezmoi"

detect() {
    # Default
    local kind="unknown"

    if [ -f /etc/os-release ]; then
        . /etc/os-release

        case "${ID:-}" in
            omarchy)
                kind="omarchy"
                ;;
            fedora|nobara)
                kind="fedora"
                ;;
            ubuntu|debian)
                kind="debian"
                ;;
            arch|endeavouros|manjaro)
                kind="arch"
                ;;
        esac
    fi

    echo "$kind"
}

echo "$(detect)" > "$HOME/.local/state/chezmoi/host-kind"


Use in templates as:

{{ $host := (readFile "~/.local/state/chezmoi/host-kind") | trim }}

4. Install mise (user-only fallback)

Create: run_once_before_20-install-mise.sh

#!/usr/bin/env bash
set -euo pipefail

if command -v mise >/dev/null 2>&1; then
    exit 0
fi

curl https://mise.run | sh

5. Install chezmoi (via mise if possible)

Create: run_once_before_30-install-chezmoi.sh

#!/usr/bin/env bash
set -euo pipefail

if command -v chezmoi >/dev/null 2>&1; then
    exit 0
fi

if command -v mise >/dev/null 2>&1; then
    mise install chezmoi
    exit 0
fi

sh -c "$(curl -fsLS get.chezmoi.io)"

6. Set shell after apply

Create: run_once_after_10-set-shell.sh

#!/usr/bin/env bash
set -euo pipefail

if ! command -v zsh >/dev/null 2>&1; then
    exit 0
fi

ZSH_BIN="$(command -v zsh)"
if [ "${SHELL:-}" != "$ZSH_BIN" ]; then
    if command -v sudo >/dev/null 2>&1; then
        sudo chsh -s "$ZSH_BIN" "$USER"
    fi
fi

7. mise config

All versions live in:

dotfiles/dot_config/mise/config.toml

[tools]
lsd = "latest"
zoxide = "latest"
zellij = "latest"
yazi = "latest"
lazygit = "latest"
nushell = "latest"
opencode = "latest"
ripgrep = "latest"
jq = "latest"

[settings]
experimental = true

[env]
PATH = "{{ tool_bin_paths }}"

8. Zsh config with host-specific imports

Create: dot_config/zsh/.zshrc.tmpl

{{ $host := (readFile "~/.local/state/chezmoi/host-kind") | trim }}

# mise init
eval "$(mise activate zsh)"

# Common config
export EDITOR="nvim"

# Host overrides
case "{{$host}}" in
  omarchy)
    source ~/.config/shell/omarchy.sh
    ;;
  arch|fedora|debian)
    source ~/.config/shell/linux.sh
    ;;
  macos)
    source ~/.config/shell/macos.sh
    ;;
esac

9. Host-specific shells
dot_config/shell/omarchy.sh.tmpl
# Omarchy-specific environment settings
export PATH="/usr/bin:$PATH"

dot_config/shell/linux.sh.tmpl
# Linux generic
export PATH="/usr/local/bin:$PATH"

dot_config/shell/macos.sh.tmpl
# macOS specifics
export PATH="/opt/homebrew/bin:$PATH"

10. Optional: Host-aware config inside templates

Anywhere in chezmoi templates:

{{ $h := (readFile "~/.local/state/chezmoi/host-kind") | trim }}
{{ if eq $h "omarchy" }}
# Omarchy-specific config
{{ end }}

11. Final workflow
git clone git@github.com:you/dotfiles.git
cd dotfiles
./setup.sh


Config flow:

setup.sh ensures mise + chezmoi

chezmoi init (first run)

run_once scripts detect host + install things

apply runs (every time)

run_after scripts sync tools + set shell

Every further run just applies.
