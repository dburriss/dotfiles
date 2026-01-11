# Usage
Add the following near the bottom of *bashrc*.

```bash
# User customizations (chezmoi-managed)
[ -d "$HOME/.bashrc.d" ] && for f in "$HOME/.bashrc.d"/*.sh; do [ -r "$f" ] && . "$f"; done
```
