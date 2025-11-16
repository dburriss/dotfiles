#!/usr/bin/env bash
set -euo pipefail

echo "[hook] Ensuring mise is installed"
if command -v mise >/dev/null 2>&1; then
    echo "[hook] mise already present"
    exit 0
fi

echo "[hook] Installing mise"
curl https://mise.run | sh
echo "[hook] mise installed"