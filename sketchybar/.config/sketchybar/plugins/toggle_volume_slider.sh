#!/usr/bin/env sh

width="$(sketchybar --query volume_slider | /usr/bin/awk -F'[: ,]+' '/"width"/ { print $3; exit }')"

if [ "${width:-0}" -gt 0 ]; then
  sketchybar --animate tanh 30 --set volume_slider slider.width=0
else
  sketchybar --animate tanh 30 --set volume_slider slider.width=100
fi
