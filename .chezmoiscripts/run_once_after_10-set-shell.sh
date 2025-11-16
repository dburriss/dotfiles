#!/usr/bin/env bash
set -euo pipefail

echo "[hook] Ensuring zsh is default shell"
if ! command -v zsh >/dev/null 2>&1; then
    echo "[hook] zsh not found, skipping shell change"
    exit 0
fi

ZSH_BIN="$(command -v zsh)"
if [ "${SHELL:-}" = "$ZSH_BIN" ]; then
    echo "[hook] zsh already default"
    exit 0
fi

if command -v sudo >/dev/null 2>&1; then
    echo "[hook] Setting zsh as default shell"
    sudo chsh -s "$ZSH_BIN" "$USER"
    echo "[hook] Default shell updated to zsh"
fi