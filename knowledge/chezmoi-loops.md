# Chezmoi Loops – What Went Wrong

## 1. Template-variable chicken-and-egg
**Symptom**:  
`mise ERROR Variable tool_bin_paths not found in context while rendering '__tera_one_off'`  
repeats every apply, even after "fixing" the source file.

**Root cause**:  
- The applied `~/.config/mise/config.toml` still contained `{{ tool_bin_paths }}`  
- Chezmoi re-parses that file on every run; if the variable is undefined, apply aborts before any update happens  
→ you never get a chance to overwrite the broken file.

**Escape hatch**:  
- Comment-out or remove the template line **in the source first**, then apply.  
- Only re-introduce templates after the variable is defined in `chezmoi.toml` data.

## 2. "Source looks good, applied is stale"
**Symptom**:  
`grep` shows source is fixed, but `cat ~/.config/mise/config.toml` still shows old content.

**Why**:  
- Chezmoi skipped the file because its **entry state** (mod-time/hash) hadn’t changed  
- Touching the source file or `chezmoi state delete-bucket entryState` forces a re-eval.

## 3. Hook scripts cached forever
**Symptom**:  
Added debug `echo` lines, but output never changes.

**Why**:  
- `run_once_*` and `run_onchange_*` scripts are keyed by **content hash**  
- Append a comment or whitespace to invalidate the cache, or use `chezmoi state delete-bucket scriptState`.

## 4. Nested-path hell
**Symptom**:  
Scripts land under `Projects/dotfiles/literal_dot_config/…` instead of source root.

**Why**:  
- `chezmoi add` invoked outside repo root → chezmoi mirrors full path  
- Always `cd` into the dotfiles repo before `chezmoi add`, or place files directly in `.chezmoiscripts/` (which is already in the source tree).

## 5. "I removed the file but it’s still there"
**Why**:  
- Deleting from **working tree** doesn’t delete from **source**  
- Use `chezmoi remove <target>` or manually delete from `~/.local/share/chezmoi/…`.

## Quick checklist to break a loop
1. `chezmoi state delete-bucket entryState scriptState`  
2. Verify source file is really fixed: `chezmoi source-path` + `cat …`  
3. Touch source file or append comment to change hash  
4. Re-apply with `--force`  
5. Only then re-introduce dynamic templates once variables exist

Remember: chezmoi never trusts the working tree—only the source tree.

## Debug commands cheat-sheet
| What you want | Command |
|---------------|---------|
| See what chezmoi thinks the source path is | `chezmoi source-path` |
| List every run-script it sees | `find "$(chezmoi source-path)" -name 'run_*.sh' -type f` |
| Dry-run apply (safe) | `chezmoi apply --dry-run --verbose` |
| Force re-apply everything | `chezmoi apply --force` |
| Clear *all* script execution memory | `chezmoi state delete-bucket scriptState entryState` |
| Check why a file is skipped | `chezmoi diff <target>` |
| View last script hash / run status | `chezmoi state get-bucket scriptState` |
| Manually touch a source file to bump its state | `echo "# $(date +%s)" >> "$(chezmoi source-path)/path/to/file"` |
| See full template-render trace | `chezmoi apply --verbose 2>&1 | less` |
| Test a template snippet | `chezmoi execute-template '{{ .chezmoi.os }}'` |

Tip: always run from inside your dotfiles repo so paths resolve correctly.