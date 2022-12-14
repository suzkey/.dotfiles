export LC_MESSAGES=en_US.UTF-8
export EDITOR=nvim

source $ZDOTDIR/zi.zsh
setopt hist_ignore_dups
setopt sharehistory

if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Settings for WSL
if command -v wslpath &> /dev/null; then
    alias clip="/mnt/c/tools/neovim/nvim-win64/bin/win32yank.exe -i"
    # appendWindowsPath is set to false in wsl.conf
    export PATH="/mnt/c/Users/sk/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"
fi

if command -v xclip &> /dev/null; then
    alias clip="xclip -sel clip"
fi

# ================================
# Aliases
# ================================

alias ls="lsd"
alias la="lsd -la"
alias remap="xmodmap ~/.Xmodmap"

if [[ `uname` == "Darwin" ]]; then
    alias clip="pbcopy"
    alias sortlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
fi

# ================================
# Settings for toolchains
# ================================

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Ocaml
if [ -x "$(command -v opam)" ]; then
    eval $(opam env)
fi

# Golang
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# starship
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
eval "$(starship init zsh)"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Gradle
if [ -d "/opt/gradle/gradle-7.5.1" ]; then
    export PATH="$PATH:/opt/gradle/gradle-7.5.1/bin"
fi

# nix
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . /home/sk/.nix-profile/etc/profile.d/nix.sh
fi

# zoxide
eval "$(zoxide init zsh)"

# npm
export PATH="$PATH:$HOME/.npm/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"