#!/usr/bin/env sh

batt_info="$(pmset -g batt)"
charge="$(printf '%s\n' "$batt_info" | /usr/bin/grep -Eo '[0-9]+%' | /usr/bin/head -n 1 | /usr/bin/tr -d '%')"
icon="!"
white=0xffcad3f5
green=0xffa6da95
red=0xffed8796
color="$white"

if printf '%s\n' "$batt_info" | /usr/bin/grep -q "AC Power"; then
  icon="􀢋"
  color="$green"
elif [ -n "$charge" ] && [ "$charge" -gt 80 ]; then
  icon="􀛨"
elif [ -n "$charge" ] && [ "$charge" -gt 60 ]; then
  icon="􀺸"
elif [ -n "$charge" ] && [ "$charge" -gt 40 ]; then
  icon="􀺶"
elif [ -n "$charge" ] && [ "$charge" -gt 20 ]; then
  icon="􀛩"
else
  icon="􀛪"
  color="$red"
fi

sketchybar --set "$NAME" icon="$icon" icon.color="$color" label="${charge:-?}%"
