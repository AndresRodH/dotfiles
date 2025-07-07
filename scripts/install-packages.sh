#!/bin/zsh

# macOS package installation script
# This replaces the chezmoi template functionality

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script is for macOS only"
    exit 1
fi

echo "Installing/updating Homebrew packages..."

# Install homebrew if not present
which -s brew
if [[ $? != 0 ]]; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages
brew bundle --upgrade --file=/dev/stdin <<EOF
tap "FelixKratz/formulae"
tap "jesseduffield/lazydocker"
tap "jesseduffield/lazygit"
tap "oven-sh/bun"

brew "aws-sso-cli"
brew "awscli"
brew "bat"
brew "btop"
brew "bun"
brew "eza"
brew "fd"
brew "fnm"
brew "fzf"
brew "gh"
brew "git-delta"
brew "go"
brew "jesseduffield/lazydocker/lazydocker"
brew "jesseduffield/lazygit/lazygit"
brew "lua"
brew "neofetch"
brew "neovim"
brew "ripgrep"
brew "sketchybar"
brew "starship"
brew "stow"
brew "thefuck"
brew "tlrc"
brew "tmux"
brew "tree"
brew "yarn"
brew "zoxide"

cask "aerospace"
cask "font-hack-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-sf-pro"
cask "font-sketchybar-app-font"
cask "ghostty"
cask "insomnia"
cask "iterm2"
cask "orbstack"
cask "raycast"
cask "slack"
cask "spotify"
cask "whatsapp"
cask "zen-browser"

EOF

echo "Package installation complete!"