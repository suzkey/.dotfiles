#!/bin/bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

# Install packages
case $OSTYPE in

    darwin*)
        DISTRO="macos"

        brew tap delphinus/sfmono-square
        brew install \
            git \
            zsh \
            curl \
            tmux \
            tig \
            starship \
            exa \
            ripgrep \
            zoxide \
            sfmono-square
        # If failed to install Neovim, see https://github.com/neovim/neovim/issues/16217#issuecomment-959793388
        brew install --HEAD neovim

        # Install GUI applications
        brew tap wez/wezterm
        brew install --cask \
            alacritty \
            firefox \
            google-japanese-ime \
            karabiner-elements \
            keyboardcleantool \
            spotify \
            wireshark
        brew install wez/wezterm/wezterm-nightly
        ;;

    linux*)
        DISTRO="linux"

        if command -v dnf &> /dev/null; then
            # Install packages from dnf
            dnf_install
        else
            echo "Command dnf not found. Unsupported distribution."
            exit 1
        fi

        # Build and Install Neovim from source
        git clone https://github.com/neovim/neovim /tmp/neovim && cd /tmp/neovim
        make CMAKE_BUILD_TYPE=release
        sudo make install
        cd $HOME

        # Install starship
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y

        # Install Rust
        curl --proto ='https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

        # Install Deno (Mainly used for Neovim plugins)
        curl -fsSL https://deno.land/install.sh | sh
        ;;

    *)
        echo "Could not identify the OS."
        exit 1
        ;;

esac

info "Finished package installation."

# Clone dotfiles repo and create symlinks
git clone https://github.com/shiomiyan/dotfiles.git ~/dotfiles
create_symlinks
info "Symlinks to dotfiles has been created."

#if ! command -v wslpath &> /dev/null ; then
#    # win32yank for Vim or Neovim
#    if [ ! -e /usr/local/bin/win32yank.exe ]; then
#        curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
#        unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
#        chmod +x /tmp/win32yank.exe
#        sudo mv /tmp/win32yank.exe /usr/local/bin/
#    fi
#fi

# Install Neovim Plugins
nvim -es -u ~/.config/nvim/init.vim -i NONE -c "PlugInstall" -c "qa"

function dnf_install() {
    # Upgrade current packages
    sudo dnf -y upgrade

    # Install toolchains
    sudo dnf -y install \
        git \
        zsh \
        wget \
        unzip \
        tmux \
        nodejs \
        openssl-devel \
        ripgrep \
        zoxide

    # Install Neovim build dependencies
    sudo yum -y install ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl
}

function create_symlinks() {
    # Create symlinks and backup configs if exists
    local TARGETS=(".zshrc", ".config", ".tmux.conf")
    mkdir /tmp/dotfiles.backup
    for target in "${TARGETS[@]}" ; do
        if [[ -f "$HOME/$target" ]] then
            mv "$HOME/$target" "/tmp/dotfiles.backup/$target"
        fi
        ln -sf "$HOME/dotfiles/$target" "$HOME/$target"
    done
}

BOLD="$(tput bold 2>/dev/null || printf "")"
UNDERLINE="$(tput smul 2>/dev/null || printf "")"
RED="$(tput setaf 1 2>/dev/null || printf "")"
GREEN="$(tput setaf 2 2>/dev/null || printf "")"
YELLOW="$(tput setaf 3 2>/dev/null || printf "")"
BLUE="$(tput setaf 4 2>/dev/null || printf "")"
MAGENTA="$(tput setaf 5 2>/dev/null || printf "")"
NO_COLOUR="$(tput sgr0 2>/dev/null || printf "")"

function info() {
    printf '%s\n' "${BOLD}${MAGENTA}==> $*${NO_COLOUR}"
}

info "Setup succeed."
info "To update default shell, run: sudo usermod -s \`which zsh\` \$USER"