#!/usr/bin/env sh

# Aerospace workspace plugin — shows workspace number + app icons

AEROSPACE="/opt/homebrew/bin/aerospace"

if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  WS_ACTIVE=0xff1e1e2e
  WS_INACTIVE=0xffbac2de
  WS_HIGHLIGHT=0xffcba6f7
else
  WS_ACTIVE=0xffeff1f5
  WS_INACTIVE=0xff7c7f93
  WS_HIGHLIGHT=0xff8839ef
fi

icon_for_app() {
  case "$1" in
    *"Spotify"*)         echo ":spotify:" ;;
    *"Music"*)           echo ":music:" ;;
    *"Discord"*)         echo ":discord:" ;;
    *"Slack"*)           echo ":slack:" ;;
    *"Ghostty"*|*"ghostty"*) echo ":ghostty:" ;;
    *"Safari"*)          echo ":safari:" ;;
    *"Firefox"*)         echo ":firefox:" ;;
    *"Zen"*)             echo ":zen_browser:" ;;
    *"Chrome"*|*"Chromium"*) echo ":google_chrome:" ;;
    *"Code"*|*"Cursor"*) echo ":code:" ;;
    *"Terminal"*|*"iTerm"*) echo ":terminal:" ;;
    *"Notes"*)           echo ":notes:" ;;
    *"Messages"*)        echo ":messages:" ;;
    *"Mail"*)            echo ":mail:" ;;
    *"Finder"*)          echo ":finder:" ;;
    *"System Preferences"*|*"System Settings"*) echo ":gear:" ;;
    *"WhatsApp"*)        echo ":whats_app:" ;;
    *"Teams"*)           echo ":microsoft_teams:" ;;
    *"zoom"*|*"Zoom"*)   echo ":zoom:" ;;
    *"Figma"*)           echo ":figma:" ;;
    *"Linear"*)          echo ":linear:" ;;
    *"Notion"*)          echo ":notion:" ;;
    *"Obsidian"*)        echo ":obsidian:" ;;
    *"Raycast"*)         echo ":raycast:" ;;
    *"1Password"*)       echo ":passwords:" ;;
    *)                   echo ":default:" ;;
  esac
}

ws="$1"
focused="$("$AEROSPACE" list-workspaces --focused 2>/dev/null)"

# Get windows in this workspace
windows="$("$AEROSPACE" list-windows --workspace "$ws" 2>/dev/null)"

# Build icon string from the apps; the workspace number is the label.
icon_str=""

if [ -n "$windows" ]; then
  apps="$(printf '%s\n' "$windows" | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}' | sort -u | head -3)"

  apps_tmp="$(mktemp -t sketchybar-apps)"
  printf '%s\n' "$apps" > "$apps_tmp"
  while IFS= read -r app; do
    [ -n "$app" ] || continue
    app_icon="$(icon_for_app "$app")"
    if [ -n "$icon_str" ]; then
      icon_str="$icon_str  $app_icon"
    else
      icon_str="$app_icon"
    fi
  done < "$apps_tmp"
  rm -f "$apps_tmp"
fi

if [ "$focused" = "$ws" ]; then
  sketchybar --set "$NAME" \
    icon="$ws" \
    icon.font="JetBrainsMono Nerd Font Mono:Regular:16.0" \
    icon.color="$WS_ACTIVE" \
    label="$icon_str" \
    label.font="sketchybar-app-font:Regular:14.0" \
    label.color="$WS_ACTIVE" \
    label.y_offset=-1 \
    background.drawing=on \
    background.color="$WS_HIGHLIGHT" \
    background.height=24 \
    background.corner_radius=12
else
  sketchybar --set "$NAME" \
    icon="$ws" \
    icon.font="JetBrainsMono Nerd Font Mono:Regular:16.0" \
    icon.color="$WS_INACTIVE" \
    label="$icon_str" \
    label.font="sketchybar-app-font:Regular:14.0" \
    label.color="$WS_INACTIVE" \
    label.y_offset=-1 \
    background.drawing=off
fi
