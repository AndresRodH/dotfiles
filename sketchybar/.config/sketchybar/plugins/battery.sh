#!/usr/bin/env sh

batt_info="$(pmset -g batt)"
charge="$(printf '%s\n' "$batt_info" | grep -Eo '[0-9]+%' | head -n 1 | tr -d '%')"

if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  TEXT_COLOR=0xffcdd6f4
  CHARGED_COLOR=0xffa6e3a1
  LOW_COLOR=0xfff38ba8
else
  TEXT_COLOR=0xff4c4f69
  CHARGED_COLOR=0xff40a02b
  LOW_COLOR=0xffd20f39
fi

if printf '%s\n' "$batt_info" | grep -q "AC Power"; then
  icon="󰂄"
  color="$CHARGED_COLOR"
elif [ -n "$charge" ] && [ "$charge" -gt 20 ]; then
  icon="󰁹"
  color="$TEXT_COLOR"
else
  icon="󰂎"
  color="$LOW_COLOR"
fi

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="${charge:-?}%"
