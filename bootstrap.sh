#!/bin/bash

set -e

# macOS-only dotfiles bootstrap script

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

echo_step() {
  echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo_error "This dotfiles setup is designed for macOS only."
  echo "Current OS: $OSTYPE"
  exit 1
fi

# Get the directory of this script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$DOTFILES_DIR/.backup/$(date +%Y%m%d_%H%M%S)"

echo_info "🍎 Starting macOS dotfiles bootstrap..."
echo_info "Dotfiles directory: $DOTFILES_DIR"
echo_info "Backup directory: $BACKUP_DIR"

# Check if Homebrew is installed, install if not
echo_step "Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
  echo_warn "Homebrew is not installed. Installing Homebrew..."
  echo_info "This may take a few minutes and will require your password..."

  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for current session
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    # Apple Silicon Macs
    echo_info "Adding Homebrew to PATH (Apple Silicon)..."
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    # Intel Macs
    echo_info "Adding Homebrew to PATH (Intel)..."
    eval "$(/usr/local/bin/brew shellenv)"
  else
    echo_error "Homebrew installation may have failed. Please check the output above."
    exit 1
  fi

  echo_info "✓ Homebrew installed successfully"
else
  echo_info "✓ Homebrew is already installed"
fi

# Check if stow is installed, install if not
echo_step "Checking for GNU Stow..."
if ! command -v stow &>/dev/null; then
  echo_warn "GNU Stow is not installed. Installing via Homebrew..."
  echo_info "Installing stow..."
  brew install stow
  echo_info "✓ GNU Stow installed successfully"
else
  echo_info "✓ GNU Stow is already installed"
fi

# Install all macOS packages via Homebrew
echo_step "Installing macOS packages via Homebrew..."
if [ -f "$DOTFILES_DIR/scripts/install-packages.sh" ]; then
  echo_info "Installing CLI tools, applications, and fonts..."
  "$DOTFILES_DIR/scripts/install-packages.sh"
  echo_info "✓ Package installation complete"
else
  echo_warn "Package installation script not found, skipping..."
fi

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

# Function to backup existing files
backup_existing_files() {
  local package=$1
  local package_dir="$DOTFILES_DIR/$package"

  if [ ! -d "$package_dir" ]; then
    return 0
  fi

  echo_info "Checking for existing files in package: $package"

  # Find all files that would be symlinked by stow
  local files_to_backup=()
  while IFS= read -r -d '' file; do
    # Get relative path from package directory
    local rel_path="${file#"$package_dir"/}"
    local target_path="$HOME/$rel_path"

    # Check if target exists and is not already a symlink to our dotfiles
    if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
      files_to_backup+=("$target_path")
    elif [ -L "$target_path" ]; then
      # Check if symlink points to our dotfiles
      local link_target
      link_target=$(readlink "$target_path")
      if [[ "$link_target" != *"$DOTFILES_DIR"* ]]; then
        files_to_backup+=("$target_path")
      fi
    fi
  done < <(find "$package_dir" -type f -print0)

  # Backup files if any exist
  if [ ${#files_to_backup[@]} -gt 0 ]; then
    mkdir -p "$BACKUP_DIR"
    echo_warn "Found ${#files_to_backup[@]} existing file(s) for $package package"

    for file_path in "${files_to_backup[@]}"; do
      local rel_path="${file_path#"$HOME"/}"
      local backup_path="$BACKUP_DIR/$rel_path"
      local backup_dir
      backup_dir=$(dirname "$backup_path")

      echo_info "  Backing up: ~/$rel_path"
      mkdir -p "$backup_dir"
      mv "$file_path" "$backup_path"
    done

    # Create a manifest for this package
    printf '%s\n' "${files_to_backup[@]}" >>"$BACKUP_DIR/.manifest_$package"
  fi
}

# Function to install a package with stow
install_package() {
  local package=$1

  if [ -d "$DOTFILES_DIR/$package" ]; then
    echo_info "Installing $package..."

    # Backup existing files first
    backup_existing_files "$package"

    # Install with stow
    stow -d "$DOTFILES_DIR" -t "$HOME" "$package"
    echo_info "✓ $package installed successfully"
  else
    echo_warn "Package $package not found, skipping..."
  fi
}

# Install packages
echo_step "Installing dotfiles packages..."
for package in "${PACKAGES[@]}"; do
  install_package "$package"
done

# Create backup info file
if [ -d "$BACKUP_DIR" ]; then
  cat >"$BACKUP_DIR/.backup_info" <<EOF
# Dotfiles Backup Information
# Created: $(date)
# Dotfiles Directory: $DOTFILES_DIR
# 
# This backup was created during dotfiles installation.
# To restore these files, run: $DOTFILES_DIR/uninstall.sh --restore
EOF
  echo_info "📦 Backup created at: $BACKUP_DIR"
fi

# Install Zap
echo_step "Installing Zap (Zsh plugin manager)..."
if [ -f "$DOTFILES_DIR/scripts/install-zap.sh" ]; then
  "$DOTFILES_DIR/scripts/install-zap.sh"
else
  echo_warn "Zap installation script not found, skipping..."
fi

echo_info "🎉 macOS dotfiles bootstrap complete!"
echo_info ""
echo_info "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Open tmux and install plugins: <C-a>I"
echo "  3. Open Neovim and let LazyVim install plugins"
echo "  4. Rebuild bat cache: bat cache --build"
echo ""
if [ -d "$BACKUP_DIR" ]; then
  echo_info "📦 Your original files have been backed up to:"
  echo "   $BACKUP_DIR"
  echo "   To restore them, run: ./uninstall.sh --restore"
fi

