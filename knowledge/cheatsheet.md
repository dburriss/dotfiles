# Chezmoi Cheatsheet

- **Purpose:** Manage dotfiles and personal configuration files across multiple machines.
- **Basic Commands:**
  - `chezmoi add <file>`: Add a file to be managed.
  - `chezmoi apply`: Apply the changes from the dotfiles to the system.
  - `chezmoi diff`: Show differences between current files and the managed dotfiles.
  - `chezmoi edit <file>`: Edit a file in the source directory.
  - `chezmoi cd`: Change directory to the source directory of managed files.
- **Templates:** Use Go templating language with double curly braces `{{ }}` to create dynamic dotfiles.
  - Example: `{{ .name | quote }}` inserts a quoted name variable.
- **File Encryption:** `chezmoi add --encrypt <file>` to securely version secrets.
- **Hooks:** Scripts prefixed with `run_once_` run once on apply; `run_onchange_` run when the file changes.
- **Ignore Files:** `.chezmoignore` can dynamically exclude files based on environment conditions.


### Mise Cheat Sheet
- **Purpose:** Unified version and environment manager with task runner for development tools.
- **Activation Setup:**
  - Add to shell profile: `echo 'eval "$(mise activate zsh)"' >> ~/.zshrc` (replace with your shell).
- **Install and Activate Tools:**
  - `mise use <tool>@<version>`: Installs and activates a tool version, e.g., `mise use node@22`.
  - The tool and version are recorded in `mise.toml`.
- **Run Tasks:**
  - Define tasks in `mise.toml` under `[tasks]`, e.g., `test = "npm run test"`.
  - Run a task with `mise run <task>`.
- **Execute Commands:**
  - `mise exec <tool>@<version> -- <command>` runs commands with a specific tool version without full shell activation.
- **Manage Environment Variables:** Configure env vars per project in `mise.toml` under `[env]`.
- **Update and Maintenance:**
  - `mise upgrade <tool>@<version>` to upgrade tools.
  - `mise uninstall <tool>@<version>` to remove tools.
  - `mise self-update` to update the mise version itself.
- **Helpful Flags:**
  - `-q` quiet mode.
  - `-v` verbose.
  - `-y` answer yes to prompts.

Both tools complement each other well: **chezmoi** for managing and applying dotfiles consistently, and **mise** for managing development tool versions, environment variables, and running project-specific tasks in a streamlined way.[2][3][4][5]

[1](https://github.com/jdx/mise)
[2](https://manuelchichi.com.ar/blog/personal-toolset-2025/)
[3](https://mise.jdx.dev/walkthrough.html)
[4](https://chezmoi.io/user-guide/frequently-asked-questions/usage/)
[5](https://mise.jdx.dev/cli/)
[6](https://www.chezmoi.io/user-guide/frequently-asked-questions/usage/)
[7](https://github.com/connorads/mise)
[8](https://www.reddit.com/r/dotfiles/comments/1bjbssz/chezmoi_add_single_file_from_etc_instead_of_home/)
[9](https://www.reddit.com/r/linux/comments/1h0muvx/what_are_your_most_favorite_commandline_tools/)
[10](https://cheatsheets.stephane.plus/admin/chezmoi/)
