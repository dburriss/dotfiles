#!/usr/bin/env bash
set -euo pipefail

echo "[hook] Starting mise tool sync"
echo "[hook] PWD=$PWD"

# Install (and upgrade) all tools declared in dot_config/mise/config.toml
SCRIPT_DIR="$(dirname "$0")"
echo "[hook] Script dir: $SCRIPT_DIR"
CONFIG="${REPO_SOURCE:-$(chezmoi source-path)/dot_config/mise/config.toml"
echo "[hook] Config path: $CONFIG"

if [ ! -f "$CONFIG" ]; then
    echo "[hook] mise config not found, skipping tool sync"
    exit 0
fi

echo "[hook] Installing any missing mise tools"
mise install --yes

echo "[hook] Upgrading mise tools to latest allowed versions"
mise upgrade --yes

echo "[hook] Regenerating mise shims"
mise reshim

echo "[hook] Finished mise tool sync"
