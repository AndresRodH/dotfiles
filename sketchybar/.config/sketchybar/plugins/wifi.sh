#!/usr/bin/env sh

# WiFi plugin — shows connection status, click for popup with details

update_wifi() {
  # Check if WiFi is on
  wifi_power="$(networksetup -getairportpower en0 2>/dev/null | awk '{print $NF}')"

  if [ "$wifi_power" != "On" ]; then
    sketchybar --set "$NAME" icon="󰤭" icon.color="0xff8c8fa1" label.drawing=off
    sketchybar --set wifi.ssid label="Wi-Fi is off"
    sketchybar --set wifi.info label=""
    return
  fi

  # Check if connected via ipconfig
  ip="$(ipconfig getifaddr en0 2>/dev/null)"

  if [ -z "$ip" ]; then
    sketchybar --set "$NAME" icon="󰤭" icon.color="0xff8c8fa1" label.drawing=off
    sketchybar --set wifi.ssid label="Not connected"
    sketchybar --set wifi.info label=""
    return
  fi

  # Connected
  sketchybar --set "$NAME" icon="󰤨" icon.color="0xff1e66f5" label.drawing=off
  sketchybar --set wifi.ssid label="Connected"
  sketchybar --set wifi.info label="Public IP: loading..."
}

case "$SENDER" in
  "mouse.entered")
    sketchybar --set "$NAME" popup.drawing=on
    public_ip="$(curl -4 -fsS --max-time 3 https://api.ipify.org 2>/dev/null)"
    sketchybar --set wifi.info label="Public IP: ${public_ip:-unavailable}"
    ;;
  "mouse.exited"|"mouse.exited.global")
    sketchybar --set "$NAME" popup.drawing=off
    ;;
  *)
    update_wifi
    ;;
esac
