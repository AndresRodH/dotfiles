#!/usr/bin/env sh

case "$INFO" in
  *'"app":"Spotify"'*|*'"app":"Music"'*) ;;
  *) exit 0 ;;
esac

state="$(printf '%s' "$INFO" | /usr/bin/sed -n 's/.*"state":"\([^"]*\)".*/\1/p')"
artist="$(printf '%s' "$INFO" | /usr/bin/sed -n 's/.*"artist":"\([^"]*\)".*/\1/p')"
title="$(printf '%s' "$INFO" | /usr/bin/sed -n 's/.*"title":"\([^"]*\)".*/\1/p')"

if [ "$state" = "playing" ]; then
  sketchybar --set "$NAME" drawing=on label="$artist: $title"
else
  sketchybar --set "$NAME" drawing=off
fi
