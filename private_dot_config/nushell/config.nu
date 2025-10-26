# config.nu
#
# Installed by:
# version = "0.102.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
# set NU_OVERLAYS with overlay list, useful for starship prompt
$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | append {||
  let overlays = overlay list | slice 1..
  if not ($overlays | is-empty) {
    $env.NU_OVERLAYS = $overlays | str join ", "
  } else {
    $env.NU_OVERLAYS = null
  }
})

# Default editor
$env.config.buffer_editor = 'nvim'

# Remove welcome message
$env.config.show_banner = false

# Cargo
$env.CARGO_HOME = $"($env.HOME)/.cargo"

# DOTNET
$env.DOTNET_ROOT = $"($env.HOME)/.dotnet"

# NodeJS 
# /home/deebo/.config/nvm/versions/node/v22.14.0/bin/
$env.NVM_ROOT = $"($env.HOME)/.config/nvm"


# OpenCode
$env.OPENCODE_ROOT = $"($env.HOME)/.opencode"

# Path
use std/util "path add"
path add "~/.local/bin"
path add ($env.CARGO_HOME | path join "bin")
path add ($env.DOTNET_ROOT | path join "tools")
path add $env.DOTNET_ROOT
path add ($env.NVM_ROOT | path join "versions/node/v22.14.0/bin")
path add ($env.OPENCODE_ROOT | path join "bin")

# Zoxide
source ~/.config/nushell/zoxide.nu

# Alias
# alias btm = btm --theme gruvbox
alias top = btm --theme gruvbox
