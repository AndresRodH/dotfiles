#!/bin/bash

set -e

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

# Get the directory of this script
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_BASE_DIR="$DOTFILES_DIR/.backup"

# Check for restore flag
RESTORE_BACKUPS=false
if [[ "$1" == "--restore" ]]; then
  RESTORE_BACKUPS=true
fi

# Function to list available backups
list_backups() {
  if [ ! -d "$BACKUP_BASE_DIR" ]; then
    echo_info "No backups found"
    return 1
  fi

  echo_info "Available backups:"
  local backup_count=0
  for backup_dir in "$BACKUP_BASE_DIR"/*; do
    if [ -d "$backup_dir" ] && [ -f "$backup_dir/.backup_info" ]; then
      local backup_name
      backup_name=$(basename "$backup_dir")
      local backup_date
      backup_date=$(head -2 "$backup_dir/.backup_info" | tail -1 | cut -d' ' -f3-)
      echo "  $backup_name ($backup_date)"
      ((backup_count++))
    fi
  done

  if [ $backup_count -eq 0 ]; then
    echo_info "No valid backups found"
    return 1
  fi

  return 0
}

# Function to restore backups
restore_backups() {
  if ! list_backups; then
    return 1
  fi

  echo ""
  read -r -p "Enter backup directory name to restore (or 'latest' for most recent): " backup_choice

  local backup_dir=""
  if [[ "$backup_choice" == "latest" ]]; then
    backup_dir=$(find "$BACKUP_BASE_DIR" -maxdepth 1 -type d -name "*" | grep -v "^$BACKUP_BASE_DIR$" | sort | tail -1)
  else
    backup_dir="$BACKUP_BASE_DIR/$backup_choice"
  fi

  if [ ! -d "$backup_dir" ] || [ ! -f "$backup_dir/.backup_info" ]; then
    echo_error "Invalid backup directory: $backup_choice"
    return 1
  fi

  echo_info "Restoring backup from: $(basename "$backup_dir")"
  echo_warn "This will overwrite any existing dotfiles!"
  read -p "Continue? (y/N): " -n 1 -r
  echo

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo_info "Restore cancelled"
    return 0
  fi

  # Restore files
  local restored_count=0
  for manifest_file in "$backup_dir"/.manifest_*; do
    if [ -f "$manifest_file" ]; then
      local package_name
      package_name=$(basename "$manifest_file" | sed 's/.manifest_//')
      echo_info "Restoring $package_name files..."

      while IFS= read -r file_path; do
        if [ -n "$file_path" ]; then
          local rel_path="${file_path#"$HOME"/}"
          local backup_file="$backup_dir/$rel_path"

          if [ -f "$backup_file" ]; then
            local target_dir
            target_dir=$(dirname "$file_path")
            mkdir -p "$target_dir"
            mv "$backup_file" "$file_path"
            echo_info "  Restored: ~/$rel_path"
            ((restored_count++))
          fi
        fi
      done <"$manifest_file"
    fi
  done

  echo_info "✓ Restored $restored_count file(s)"

  # Ask if user wants to remove the backup
  echo ""
  read -p "Remove this backup directory? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$backup_dir"
    echo_info "Backup directory removed"
  fi
}

# Main uninstall logic
if [[ "$RESTORE_BACKUPS" == true ]]; then
  echo_step "Restoring backed up files..."
  restore_backups
  exit 0
fi

echo_warn "This will remove all symlinked dotfiles managed by stow"

# Show available backups if any
if [ -d "$BACKUP_BASE_DIR" ] && [ "$(ls -A "$BACKUP_BASE_DIR" 2>/dev/null)" ]; then
  echo_info ""
  echo_info "Available backups that can be restored:"
  list_backups || true
  echo_info ""
  echo_info "To restore backups instead of uninstalling, run: $0 --restore"
  echo_info ""
fi

read -p "Continue with uninstall? (y/N): " -n 1 -r
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

echo_step "Uninstalling dotfiles packages..."

# Uninstall each package
for package in "${PACKAGES[@]}"; do
  if [ -d "$DOTFILES_DIR/$package" ]; then
    echo_info "Uninstalling $package..."
    stow -d "$DOTFILES_DIR" -t "$HOME" -D "$package"
  fi
done

echo_info "✓ Dotfiles uninstalled successfully!"

# Offer to restore backups
if [ -d "$BACKUP_BASE_DIR" ] && [ "$(ls -A "$BACKUP_BASE_DIR" 2>/dev/null)" ]; then
  echo ""
  read -p "Would you like to restore your backed up files? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    restore_backups
  fi
fi

