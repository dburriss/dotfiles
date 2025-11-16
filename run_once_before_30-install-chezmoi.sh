#!/usr/bin/env bash
set -euo pipefail

echo "[hook] Ensuring chezmoi is installed"
if command -v chezmoi >/dev/null 2>&1; then
    echo "[hook] chezmoi already present"
    exit 0
fi

if command -v mise >/dev/null 2>&1; then
    echo "[hook] Installing chezmoi via mise"
    mise install chezmoi
    echo "[hook] chezmoi installed"
    exit 0
fi

echo "[hook] Installing chezmoi via script"
sh -c "$(curl -fsLS get.chezmoi.io)"
echo "[hook] chezmoi installed"