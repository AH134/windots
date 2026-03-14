#!/bin/bash

# Fedora 43 WSL Setup Script
set -e

install_base() {
    echo "--- Updating and Installing Base Packages ---"
    sudo dnf update -y
    sudo dnf install -y \
        @development-tools \
        @c-development \
        git zsh zoxide nodejs npm golang cmake curl wget neovim \
        util-linux-user zsh-syntax-highlighting zsh-autosuggestions \
        gawk btop stow
}

install_tools() {
    echo "--- Installing Rust, Eza, Starship, and NVM ---"

    sudo dnf copr enable atim/starship -y
    sudo dnf install starship -y
    
    if ! command -v cargo > /dev/null 2>&1; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    cargo install eza

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
}

setup_zsh() {
    echo "--- Configuring Zsh ---"
    sudo usermod -s "/usr/bin/zsh" "$USER"

    touch "$HOME/.zsh_history"
}

setup_stow() {
    echo "--- Setting up dotfiles with Stow ---"
    read -p "Do you want to use 'stow' to symlink dotfiles? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        stow -d "$HOME/windots" wsl
        echo "Dotfiles symlinked with stow."
    else
        echo "Skipping stow setup."
    fi
}

setup_git() {
    # optional git ssh setup
    read -p "Do you want to configure Git with SSH keys? (y/n): " choice
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        echo "Skipping Git configuration."
        return
    fi

    read -p "Enter your Git user name: " GIT_USER_NAME
    read -p "Enter your Git user email: " GIT_USER_EMAIL

    echo "--- Configuring Git ---"
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"

    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        ssh-keygen -t ed25519 -C "$GIT_USER_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
        echo "SSH key generated. Add the following public key to your GitHub account:"
        cat "$HOME/.ssh/id_ed25519.pub"
    else
        echo "SSH key already exists. Skipping generation."
    fi
}

main() {
    install_base
    install_tools
    setup_zsh
    setup_stow
    setup_git
    echo "----------------------------------------------------"
    echo "Setup Complete! Restart WSL for changes to take effect."
    echo "----------------------------------------------------"
    echo "Next Steps:"
    echo "1. Add the generated SSH public key to your GitHub account for seamless authentication."
    echo "2. Restart WSL to apply Zsh as the default shell."
    echo "3. Run "nvm install --lts" to get the latest Node.js LTS version."
    echo "4. Explore your new setup and customize further as needed!"
}

main

