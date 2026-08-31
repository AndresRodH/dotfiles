#!/usr/bin/env sh

public_ip="$(curl -4 -fsS --max-time 3 https://api.ipify.org 2>/dev/null)"

if [ -n "$public_ip" ] && printf '%s' "$public_ip" | pbcopy; then
  sketchybar --set wifi.copy label="Copied public IP"
  sleep 1
  sketchybar --set wifi.copy label="Copy public IP"
else
  sketchybar --set wifi.copy label="Copy failed"
  sleep 1
  sketchybar --set wifi.copy label="Copy public IP"
fi
