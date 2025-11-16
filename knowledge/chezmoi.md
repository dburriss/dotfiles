# Chezmoi

Chezmoi lifecycle scripts are special scripts that you place in your ChezMoi source directory to be executed automatically during the `chezmoi apply` process, which updates your dotfiles across machines. These scripts have predefined filename prefixes that determine when and how often they are run:

- `run_` scripts: Executed every time you run `chezmoi apply`. They run in alphabetical order among themselves.
- `run_onchange_` scripts: Executed only if the content of the script has changed since the last successful run. ChezMoi tracks the script content using a SHA256 hash and ensures the script does not run again unless its content changes. These scripts can be templates with dynamic content.
- `run_once_` scripts: Executed only once for each unique version of the script content. Once run successfully, they are not executed again unless the content changes.

Scripts can be also named with additional prefixes `before_` or `after_` to control when they run relative to dotfile updates, for example, `run_once_before_install-password-manager.sh`.

Important details about lifecycle scripts in ChezMoi:
- Scripts must be manually created with appropriate `run_` prefixes in the source directory or inside a `.chezmoiscripts` directory.
- Scripts should be idempotent to avoid issues with repeated or conditional executions.
- Scripts can be shell scripts or any executable binary but must include a shebang (`#!`) line or be otherwise executable.
- Template scripts (`.tmpl` suffix) allow you to insert dynamic data, and if the template output is empty, the script will not run.
- The working directory for the script execution is set to the first existing parent directory in the destination (target) tree.
- ChezMoi handles script execution by writing the script content to a temporary file with execution permissions and then running it.
- You can clear the execution state of `run_onchange_` and `run_once_` scripts using `chezmoi state delete-bucket` commands if you want to force re-execution.

This lifecycle scripting mechanism in ChezMoi allows automating custom setup steps, package installations, and other configuration tasks during dotfile management in a controlled and efficient manner.[1][2][3]

[1](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
[2](https://chezmoi.io/user-guide/use-scripts-to-perform-actions/)
[3](https://budimanjojo.com/2021/12/13/managing-dotfiles-with-chezmoi/)
[4](https://chezmoi.io/what-does-chezmoi-do/)
[5](https://www.lorenzobettini.it/2025/09/managing-kde-dotfiles-with-chezmoi-and-chezmoi-modify-manager/)
[6](https://myhomelab.gr/automation/2025/06/26/dotfiles-management.html)
[7](https://johnmathews.is/blog/chezmoi)
[8](https://www.mikekasberg.com/blog/2021/05/12/my-dotfiles-story.html)
[9](https://stoddart.github.io/2024/09/08/managing-dotfiles-with-chezmoi.html)
[10](https://r-cha.dev/blog/adopting-chezmoi/)
