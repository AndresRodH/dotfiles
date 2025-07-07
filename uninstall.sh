#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory of this script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo_warn "This will remove all symlinked dotfiles managed by stow"
read -p "Are you sure? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo_info "Uninstall cancelled"
    exit 0
fi

# List of packages to uninstall
PACKAGES=(
    "zsh"
    "git" 
    "tmux"
    "starship"
    "nvim"
    "aerospace"
    "bat"
    "delta"
    "ghostty"
    "iterm"
    "lazygit"
    "sketchybar"
)

# Uninstall each package
for package in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$package" ]; then
        echo_info "Uninstalling $package..."
        stow -d "$DOTFILES_DIR" -t "$HOME" -D "$package"
    fi
done

echo_info "Dotfiles uninstalled successfully!"