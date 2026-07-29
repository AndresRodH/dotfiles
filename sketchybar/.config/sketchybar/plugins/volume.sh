#!/usr/bin/env sh

volume="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"
icon="􀊣"

if [ "$volume" -gt 60 ]; then
  icon="􀊩"
elif [ "$volume" -gt 30 ]; then
  icon="􀊧"
elif [ "$volume" -gt 10 ]; then
  icon="􀊥"
elif [ "$volume" -gt 0 ]; then
  icon="􀊡"
fi

sketchybar --set volume_icon label="$icon" \
  --set volume_slider slider.percentage="$volume"
