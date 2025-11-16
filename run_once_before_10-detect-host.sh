#!/usr/bin/env bash
set -euo pipefail

echo "[hook] Detecting host kind"
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
echo "[hook] Host kind detected"