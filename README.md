# dotfiles

A simple macOS dotfiles setup using GNU Stow for symlink management with automatic backup and restore functionality.

## 🍎 Requirements

- **macOS** (this setup is macOS-specific)
- **Nothing else!** (bootstrap handles all dependencies automatically)

## 🚀 Quick Start (Recommended)

**One-command bootstrap:**

```bash
git clone git@github.com:AndresRodH/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./bootstrap.sh
```

This will automatically:

- Check that you're running on macOS
- Install Homebrew if not present
- Install GNU Stow via Homebrew
- Install **all CLI tools, apps, and fonts** via Homebrew (40+ packages!)
- Backup any existing dotfiles safely
- Install all dotfiles packages with stow
- Install Zap plugin manager for Zsh
- Give you next steps

## 📋 Manual Installation

If you prefer step-by-step control:

1. **Clone this repository:**

   ```bash
   git clone git@github.com:AndresRodH/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Install GNU Stow:**

   ```bash
   brew install stow
   ```

3. **Install dotfiles:**

   ```bash
   ./install.sh
   ```

4. **Install macOS packages (optional - already included in bootstrap):**

   ```bash
   ./scripts/install-packages.sh
   ```

5. **Install Zap (optional - already included in bootstrap):**

   ```bash
   ./scripts/install-zap.sh
   ```

## 🔄 Backup & Restore

The bootstrap script automatically handles existing dotfiles:

- **Automatic Backup**: Existing files are backed up to `.backup/TIMESTAMP/`
- **Safe Installation**: Never overwrites files, always backs up first
- **Easy Restore**: Restore original files anytime

### Restore Commands

```bash
# List and restore backed up files
./uninstall.sh --restore

# Uninstall dotfiles (offers to restore backups)
./uninstall.sh
```

## 📁 Structure

Each application has its own directory in the root:

- `zsh/` - Zsh configuration (.zshrc)
- `git/` - Git configuration (.gitconfig)
- `tmux/` - Tmux configuration (.tmux.conf)
- `nvim/` - Neovim configuration
- `starship/` - Starship prompt configuration
- `aerospace/` - Aerospace window manager
- `bat/` - Bat (better cat) themes
- `delta/` - Git delta themes
- `ghostty/` - Ghostty terminal configuration
- `iterm/` - iTerm2 configuration
- `lazygit/` - Lazygit configuration
- `sketchybar/` - Sketchybar configuration

## ⚡ Manual Package Management

You can install specific packages individually:

```bash
# Install only specific packages
stow zsh git tmux

# Uninstall a package
stow -D nvim

# Install all packages manually
./install.sh
```

## 🔧 Migration from Chezmoi

This setup was migrated from Chezmoi. The main differences:

- **macOS-focused**: Simplified for macOS-only usage
- **Simpler structure**: Each app gets its own stow package
- **No templating**: Plain configuration files
- **Homebrew integration**: Uses Homebrew for all package management
- **Backup system**: Automatic backup and restore functionality

### Cleaning up Chezmoi

After migrating to this stow-based setup, you can clean up your old chezmoi installation:

```bash
# Remove chezmoi configuration and data
rm -rf ~/.local/share/chezmoi  # Source directory
rm -rf ~/.config/chezmoi       # Configuration directory

# Uninstall chezmoi binary
brew uninstall chezmoi
# or if installed via script:
sudo rm /usr/local/bin/chezmoi
```

## 📦 Included Applications

- **Shell**: Zsh with Starship prompt and Zap plugin manager
- **Editor**: Neovim with LazyVim configuration
- **Terminal**: Ghostty, iTerm2
- **Window Manager**: Aerospace (macOS)
- **Status Bar**: Sketchybar (macOS)
- **Git**: Delta for diffs, Lazygit for TUI
- **Tools**: Bat, Tmux, and various CLI utilities via Homebrew

## ❓ FAQ

### My tmux looks bad

Make sure to install tmux plugins by pressing `<C-a>I` while in a tmux session.

### `bat` theme is not applied

Cache may need to be rebuilt:

```bash
bat cache --build
```

### I want to restore my original dotfiles

```bash
./uninstall.sh --restore
```

### Something went wrong during installation

Check the backup directory (`.backup/TIMESTAMP/`) - your original files are safely stored there.
