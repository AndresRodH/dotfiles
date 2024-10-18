# dotfiles

> [!NOTE]
> If you are looking for the GNU Stow-based setup, go [here](https://github.com/AndresRodH/config)

All the things I use. This targets OSX only. Tested on Intel Macs only, some tweaks may need to be made for Apple Silicon Macs.

## Requirements

1. Install Apple's Command Line Tools (they are prereqs for Git and Homebrew)

   ```sh
   xcode-select --install
   ```

2. Update XCode to the latest version. Some apps, like [lazygit](https://github.com/jesseduffield/lazygit), will fail to install otherwise

## Bootstrap a new Mac

This setup uses [chezmoi](https://www.chezmoi.io/) to manage dotfiles. To bootstrap a new Mac:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --ssh --apply AndresRodH # update this with your GitHub username if you cloned/forked this repo
```

## What's in it?

There's a lot of stuff in here. Actually, there's a lot of stuff that you may not need! [Fork this repo](https://github.com/AndresRodH/dotfiles/fork), remove what you don't use and add what you do use.

1. [zsh](https://www.zsh.org/)
   - Uses [zap](https://github.com/zap-zsh/zap) as a plugin manager
   - Aliases are set up in [aliases.zsh](`dot_config/zsh/aliases.zsh`) and exports in [exports.zsh](`dot_config/zsh/exports.zsh`)

2. [tmux](https://github.com/tmux/tmux)
   - Sets up [Tmux Plugin Manager (tpm)](https://github.com/tmux-plugins/tpm) automatically on first run
   - Remaps the prefix to `<C-a>`
   - `<C-a>I` install tmux plugins
   - `<C-a>r` reload tmux configuration
   - Check the [configuration](`dot_tmux.conf`) for a list of plugins used

3. [neovim](https://neovim.io/)
   - Uses [lazyvim](https://www.lazyvim.org/)

4. [Homebrew](https://brew.sh/) - [check what's included](run_once_before_install-packages-darwin.sh.tmpl)

5. [Git profile management](`dot_gitconfig`)

6. [Starship](https://starship.rs/) prompt

... and more!

## FAQ

### My tmux looks bad

Make sure to install to install any tmux plugins by pressing `<C-a>I` while in a tmux session.

### `bat` theme is not applied

Cache may need to be rebuilt

```sh
bat cache --build
```
