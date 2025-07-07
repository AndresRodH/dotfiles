# Dotfiles with GNU Stow

A simple dotfiles setup using GNU Stow for symlink management.

## Quick Start

1. **Clone this repository:**
   ```bash
   git clone https://github.com/AndresRodH/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Install GNU Stow:**
   ```bash
   # macOS
   brew install stow
   
   # Ubuntu/Debian
   sudo apt install stow
   
   # Arch Linux
   sudo pacman -S stow
   ```

3. **Install dotfiles:**
   ```bash
   ./install.sh
   ```

4. **Install packages (macOS only):**
   ```bash
   ./scripts/install-packages.sh
   ```

5. **Install Zap (Zsh plugin manager):**
   ```bash
   ./scripts/install-zap.sh
   ```

## Structure

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

## Manual Installation

You can install specific packages individually:

```bash
# Install only specific packages
stow zsh git tmux

# Uninstall a package
stow -D nvim
```

## Migration from Chezmoi

This setup was migrated from Chezmoi. The main differences:

- **Simpler structure**: Each app gets its own stow package
- **No templating**: Plain configuration files
- **Manual scripts**: Separate install scripts instead of chezmoi hooks
- **Standard symlinks**: Uses GNU stow's symlink management

## Included Applications

- **Shell**: Zsh with Starship prompt and Zap plugin manager
- **Editor**: Neovim with LazyVim configuration
- **Terminal**: Ghostty, iTerm2
- **Window Manager**: Aerospace
- **Status Bar**: Sketchybar
- **Git**: Delta for diffs, Lazygit for TUI
- **Tools**: Bat, Tmux, and various CLI utilities

## FAQ

### My tmux looks bad

Make sure to install to install any tmux plugins by pressing `<C-a>I` while in a tmux session.

### `bat` theme is not applied

Cache may need to be rebuilt

```sh
bat cache --build
```

### Sketchybar setup

May need to make scripts executable. Check the official [Sketchybar setup](https://felixkratz.github.io/SketchyBar/setup) for more.

## License

MIT License - see individual package licenses for more details.
