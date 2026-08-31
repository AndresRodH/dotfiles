# Omarchy Configuration Ownership

**Checked:** 2026-08-31
**Omarchy source:** [`quattro` at `b686ed8`](https://github.com/omacom/omarchy/tree/b686ed892d9c3020c3336203f6d34cc75b544e2b)
**Question:** Which paths and defaults belong to Omarchy, which are generated, and which are intended for user customization?

## Decision Summary

- Treat `/usr/share/omarchy` as Omarchy-owned package content. It contains the packaged `bin/`, `config/`, `default/`, `shell/`, `themes/`, `migrations/`, and `install/` trees. Do not stow edits there: updates replace it.
- Treat `~/.config` as the user customization surface, even when Omarchy initially seeds a file there. `omarchy refresh config ...` and reinstall operations can replace seeded files, backing up the prior version for refreshes.
- Treat `~/.local/state/omarchy/current` as generated runtime state, especially `current/theme`, `current/background`, and `theme.name`. Do not track or stow it.
- Keep Omarchy's configuration seams rather than replacing its implementation: Hyprland user Lua files, `omarchy/shell.json`, menu extensions, hooks, custom themes, and themed templates.
- This repository is macOS-specific. Aerospace, Sketchybar, iTerm2, and macOS-specific Ghostty settings have no direct Omarchy equivalent. Omarchy is Arch Linux + Hyprland + Quickshell.

## Ownership Boundaries

| Area | Omarchy owns or generates | User customization seam |
| --- | --- | --- |
| Packaged implementation | `/usr/share/omarchy/{bin,default,shell,themes,migrations,install}` and shipped config templates under `/usr/share/omarchy/config` | None in normal use. Use a user override instead; the package is replaced on update. [`Dotfiles`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/31-dotfiles.md), [`source tree`](https://github.com/omacom/omarchy/tree/b686ed892d9c3020c3336203f6d34cc75b544e2b) |
| User config | Omarchy seeds `~/.config` from its `config/` templates and can refresh individual files, preserving a `.bak.<timestamp>` copy. | `~/.config/*` is the intended place for changes. A full reinstall/reset can overwrite Omarchy defaults there. [`omarchy-refresh-config`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/bin/omarchy-refresh-config), [`Updates`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/30-updates.md) |
| Active themes | `omarchy theme set` copies stock or user theme material into `~/.local/state/omarchy/current`, generates themed files, and updates current-theme/background links. | Put authored themes in `~/.config/omarchy/themes/<name>`, extra backgrounds in `~/.config/omarchy/backgrounds/<theme>`, and optional templates in `~/.config/omarchy/themed/*.tpl`. [`theme set`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/bin/omarchy-theme-set), [`theme templates`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/bin/omarchy-theme-set-templates), [`Making your own theme`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/43-making-your-own-theme.md) |
| Hyprland | Packaged defaults in `/usr/share/omarchy/default/hypr`, including default bindings, input, look-and-feel, windows, applications, and autostart. The shipped user `hyprland.lua` loads these first. | `~/.config/hypr/hyprland.lua`, `bindings.lua`, `monitors.lua`, `input.lua`, `looknfeel.lua`, and `autostart.lua` are loaded after defaults and are the supported override points. [`hyprland.lua`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/config/hypr/hyprland.lua), [`default.hypr.omarchy`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/default/hypr/omarchy.lua), [`Keyboard/input`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/34-keyboard-mouse-trackpad.md) |
| Omarchy shell | Quickshell implements the top bar, panels, notifications, OSD, lock screen, screensaver, menu, and shell plugins. | `~/.config/omarchy/shell.json` owns the customized bar layout and idle values; `~/.config/omarchy/extensions/omarchy-menu.jsonc` adds or overrides menu rows. Use plugin commands or user plugin locations rather than editing packaged `shell/`. [`Top bar`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/05-the-top-bar.md), [`Dotfiles/menu extensions`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/31-dotfiles.md) |
| System integration | Firewall, NetworkManager integration, SSH/Docker setup, systemd units, SDDM, Limine/Plymouth, fonts, and hardware fixes are installed from Omarchy's `default/` and `install/` trees. | Use Omarchy's setup/update commands and the documented `/etc` or user-level override mechanisms for machine-specific changes. These are not portable dotfile packages. [`Networking`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/35-networking.md), [`install/config/all.sh`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/install/config/all.sh) |

### Generated theme outputs

`colors.toml` is the theme input. Omarchy's built-in templates generate or refresh configuration for the terminals (Foot, Alacritty, Ghostty, Kitty), btop, Chromium, Hyprland, Neovim, Helix, VS Code, Obsidian, and the Omarchy shell. The generated copies live in the active theme state directory, not in a dotfiles repository. A custom theme written by the user may contain its own files; a theme installed from a third-party Git repository is deliberately restricted from supplying Lua, terminal-launch configuration, or `vscode.json`.

## Defaults and Components

| Component/default | Current Omarchy behavior | Customization implication |
| --- | --- | --- |
| Terminal | Foot is the default; Alacritty, Ghostty, and Kitty are supported alternatives. Terminal selection is managed by Omarchy and the XDG terminal handler. [`Terminal`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/15-terminal.md), [`default terminal`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/bin/omarchy-default-terminal) | Customize the selected terminal's `~/.config/<terminal>/` file, but retain the theme include/config-file hook that points at the generated current theme. |
| Browser | Chromium is the base/default browser and is themed by Omarchy. Installing another browser does not select it; `omarchy default browser` updates the XDG handler. Firefox and Zen receive Wayland/policy setup but are not Omarchy-themed. [`Browsers`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/23-browsers.md), [`default browser`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/bin/omarchy-default-browser) | Do not replace browser policy/extensions/native-messaging integration with a generic browser package. Treat browser choice as an Omarchy-managed default. |
| Editor | Omarchy ships a complete `omarchy-nvim`/LazyVim setup and starts with Neovim as the editor default; other editors can be installed and selected. [`Neovim`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/16-neovim.md), [`default editor`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/bin/omarchy-default-editor) | A separate `~/.config/nvim` distribution is a deliberate replacement of Omarchy's editor, not a harmless additive override. |
| Shell and prompt | Omarchy initializes Bash and provides default aliases/functions through its packaged Bash files. Starship is the default prompt and is configured at `~/.config/starship.toml`. [`default bashrc`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/default/bashrc), [`Prompt`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/40-prompt.md) | Add personal shell exports/functions in `~/.bashrc`; customize Starship in its user config. A Zsh package is a separate shell choice, not an Omarchy desktop override. |
| App/file defaults | Omarchy seeds MIME defaults for Nautilus, imv, Evince, mpv, Neovim, Chromium, and HEY. | Reassign defaults through the desktop/XDG mechanisms; do not treat the shipped list as a universal cross-machine dotfile. [`mimeapps.list`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/default/applications/mimeapps.list), [`GUIs`](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/22-guis.md) |
| Tmux, Git, lazygit, Herdr, OpenCode, btop | Omarchy currently ships user-facing configs for these under its `config/` tree and theme-syncs some of them. | These are shared application namespaces, not safe wholesale replacements: merge intentionally or choose one owner per file. [`config tree`](https://github.com/omacom/omarchy/tree/b686ed892d9c3020c3336203f6d34cc75b544e2b/config) |

## Candidate Package Mapping

This is a boundary map only; no repository configuration changes are proposed here.

| Repository package | Relationship to Omarchy | Guidance for a future Linux/Omarchy profile |
| --- | --- | --- |
| `ghostty` | Exact path overlap at `~/.config/ghostty/config`. Omarchy's version imports generated theme state; this repository's file contains macOS-specific settings and no Omarchy theme hook. | Do not stow unchanged. Preserve Omarchy's dynamic theme integration and split platform-specific settings if Ghostty is selected. |
| `nvim` | Omarchy already supplies a complete Neovim distribution. | Choose Omarchy's Neovim or this package as the owner of `~/.config/nvim`; do not layer blindly. |
| `starship` | Exact path overlap at `~/.config/starship.toml`; this is an explicitly user-customizable Omarchy file. | A deliberate override is reasonable, but it replaces Omarchy's prompt defaults. |
| `tmux` | Omarchy uses `~/.config/tmux/tmux.conf`; this repository uses `~/.tmux.conf`, so the paths differ but may still interact through tmux's config lookup. | Verify precedence and merge before deployment; do not infer safety from the different paths. |
| `git` | Omarchy ships `~/.config/git/config`; this repository stows `~/.gitconfig`. Git may read both, and Omarchy setup can set identity. | Define precedence and identity ownership explicitly. |
| `lazygit`, `herdr` | Exact Omarchy config paths are present under `~/.config/lazygit/` and `~/.config/herdr/`. | Treat as same-file conflicts; merge or select one owner. |
| `opencode` | Omarchy ships `~/.config/opencode/opencode.json`; this repository uses `opencode.jsonc` in the same namespace. | Keep the two configurations intentional and verify OpenCode's config loading order before combining them. |
| `bat`, `delta` | No corresponding Omarchy user config package appears in the current `config/` tree, although Omarchy documents/uses enhanced shell tools. | Likely additive, subject to package/theme behavior; no desktop ownership conflict found. |
| `zsh` | Omarchy's documented default shell integration is Bash; this repository owns `~/.zshrc`. | Separate shell choice. It does not replace Omarchy's Bash integration unless the user intentionally changes shells. |
| `aerospace`, `sketchybar`, `iterm` | macOS-only window manager, status bar, and terminal components. Omarchy uses Hyprland and Quickshell instead. | Exclude from an Omarchy/Linux profile. |

## Operational Rules

1. Track authored inputs under `~/.config`, not `/usr/share/omarchy` or `~/.local/state/omarchy/current`.
2. Preserve Omarchy's generated-theme include points in terminal and application configs.
3. Prefer Omarchy commands for defaults, themes, bar/plugin changes, package installation, and system setup; use direct config edits for the documented user seams.
4. Expect `omarchy update` and explicit refresh/reinstall operations to change shipped defaults. Keep personal overrides small and reviewable so they can be reapplied after a reset.

## Sources

- [Omarchy manual: Dotfiles](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/31-dotfiles.md)
- [Omarchy manual: Updates](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/30-updates.md)
- [Omarchy manual: Themes](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/06-themes.md)
- [Omarchy manual: The top bar](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/05-the-top-bar.md)
- [Omarchy manual: Making your own theme](https://github.com/omacom/omarchy/blob/b686ed892d9c3020c3336203f6d34cc75b544e2b/manual/43-making-your-own-theme.md)
- [Official Omarchy source repository at the checked commit](https://github.com/omacom/omarchy/tree/b686ed892d9c3020c3336203f6d34cc75b544e2b)
