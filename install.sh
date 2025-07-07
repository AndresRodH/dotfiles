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

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo_error "GNU Stow is not installed. Please install it first:"
    echo "  macOS: brew install stow"
    echo "  Ubuntu/Debian: sudo apt install stow"
    echo "  Arch: sudo pacman -S stow"
    exit 1
fi

# Get the directory of this script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo_info "Installing dotfiles from $DOTFILES_DIR"

# List of packages to install
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

# Install each package
for package in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$package" ]; then
        echo_info "Installing $package..."
        stow -d "$DOTFILES_DIR" -t "$HOME" "$package"
    else
        echo_warn "Package $package not found, skipping..."
    fi
done

echo_info "Dotfiles installation complete!"
echo_info "You may need to:"
echo "  - Restart your shell or run 'source ~/.zshrc'"
echo "  - Install dependencies with './scripts/install-packages.sh'"
echo "  - Install Zap with './scripts/install-zap.sh'"