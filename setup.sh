#!/usr/bin/env bash
set -euo pipefail

REPO_SOURCE="$PWD"
CHEZMOI_VERSION="2.67.0"
export PATH="$HOME/.local/bin:$PATH"

INSTALLED=""

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

init_chezmoi() {
    export PATH="$HOME/.local/bin:$PATH"
    # ensure shell can find newly installed binaries
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
init_chezmoi