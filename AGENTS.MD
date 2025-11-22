# Agent Instructions for Dotfiles Repository

## Build/Lint/Test Commands
- This is a dotfiles repository managed with chezmoi
- No traditional build process - files are templates that get applied to the system
- Test changes by running: `chezmoi apply --dry-run --verbose` to see what would change
- To apply changes: `chezmoi apply`
- To check for differences: `chezmoi diff`

## Code Style Guidelines
- Use 2 spaces for indentation (as per stylua.toml)
- Shell scripts follow standard POSIX shell conventions
- Neovim configuration uses Lua with 2-space indentation
- Template files use chezmoi's Go template syntax
- File names with leading dots should be prefixed with `dot_` in this repo

## Naming Conventions
- Host detection scripts use `run_once_before_*` naming
- Post-apply scripts use `run_once_after_*` naming
- Template files end with `.tmpl` extension
- Shell scripts use `.sh` extension

## Error Handling
- Scripts should use `set -euo pipefail` for robust error handling
- Idempotency is crucial - all scripts should be safe to run multiple times
- Check if tools exist before installing

## Special Considerations
- This is a dotfiles repo - changes affect system configuration
- Files are templates that generate actual dotfiles when applied
- Host-specific configurations are supported via template conditionals
- Always test with dry-run before applying changes

## Aider Configuration
- Aider rules file: ~/.config/AIDER-RULEṡmd (currently empty)
- Architecture file: ARCHITECTURE.md (if exists)
- Conventions file: CONVENTIONS.md (if exists)