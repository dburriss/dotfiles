#!/usr/bin/env bash
set -euo pipefail

echo "[hook] Starting mise tool sync"

# Install (and upgrade) all tools declared in dot_config/mise/config.toml
CONFIG="${REPO_SOURCE:-$(dirname "$0")}/dot_config/mise/config.toml"

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