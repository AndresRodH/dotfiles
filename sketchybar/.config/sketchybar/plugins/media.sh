#!/usr/bin/env sh

# Poll Spotify directly. The media_change event is unreliable on newer macOS.
if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  MEDIA_ACCENT=0xffcba6f7
  MEDIA_MUTED=0xff7f849c
else
  MEDIA_ACCENT=0xff8839ef
  MEDIA_MUTED=0xff8c8fa1
fi

track_info="$(osascript <<'APPLESCRIPT' 2>/dev/null
if application "Spotify" is running then
  tell application "Spotify"
    set playerState to player state as text
    if playerState is not "stopped" then
      return playerState & tab & artist of current track & tab & name of current track
    end if
  end tell
end if
return ""
APPLESCRIPT
)"

if [ -z "$track_info" ]; then
  sketchybar --set "$NAME" drawing=off
  sketchybar --set sep_media_wifi drawing=off
  exit 0
fi

state="$(printf '%s' "$track_info" | cut -f1)"
artist="$(printf '%s' "$track_info" | cut -f2)"
title="$(printf '%s' "$track_info" | cut -f3-)"

case "$state" in
  playing)
    sketchybar --set "$NAME" drawing=on icon="󰎈" icon.color="$MEDIA_ACCENT" label="$artist - $title" ;;
  paused)
    sketchybar --set "$NAME" drawing=on icon="󰏤" icon.color="$MEDIA_MUTED" label="$artist - $title" ;;
  *)
    sketchybar --set "$NAME" drawing=off ;;
esac

sketchybar --set sep_media_wifi drawing=on

if [ "$state" = "playing" ]; then
  sketchybar --set media.play icon="󰏤"
else
  sketchybar --set media.play icon="󰐊"
fi
