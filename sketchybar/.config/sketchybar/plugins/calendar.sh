#!/usr/bin/env sh

if [ "$SENDER" = "appearance_change" ]; then
  sketchybar --reload
  exit 0
fi

sketchybar --set "$NAME" icon="󰃶" label="$(date '+%a %d %b %H:%M')"
