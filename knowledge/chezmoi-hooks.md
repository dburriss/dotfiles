# Chezmoi Hooks – Session Learnings

## 1. Location matters
- Lifecycle scripts must live **inside chezmoi’s source tree** (`~/.local/share/chezmoi/…`) to be scheduled.
- Dropping them into `.chezmoiscripts/` at the repo root is the cleanest way; chezmoi auto-discovers them.

## 2. Naming controls frequency
- `run_once_*` – executes only once per unique content (tracked by SHA-256).  
- `run_after_*` – executes **every** `chezmoi apply` (idempotent by design).  
- `before_` / `after_` prefixes control timing relative to dotfile updates.

## 3. Idempotency is built-in
- Scripts should use `command -v` checks and early exits so repeated runs are safe.  
- `mise install --yes` and `mise upgrade --yes` are already idempotent.

## 4. Template pitfalls
- Avoid undefined template variables (e.g., `{{ tool_bin_paths }}`) in files that chezmoi will **parse** during apply.  
- If you need dynamic values, define them in `chezmoi.toml` data section or remove the template line until the variable exists.

## 5. Hook visibility
- Add clear `[hook] Started …` / `[hook] Finished …` banners so logs show exactly what ran.  
- Use `set -euo pipefail` and print banners to make failures obvious.

## 6. One-time repo setup
- After creating `.chezmoiscripts/` and populating it, commit the folder.  
- Any future clone already contains the hooks — no extra bootstrap step needed.

Result: clone → `./setup.sh` → hooks run automatically and idempotently.