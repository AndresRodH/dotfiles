#!/usr/bin/env sh

workspace="$1"
focused="${FOCUSED_WORKSPACE:-}"

if [ -z "$focused" ] && command -v aerospace >/dev/null 2>&1; then
  focused="$(aerospace list-workspaces --focused 2>/dev/null)"
fi

if [ "$focused" = "$workspace" ]; then
  sketchybar --set "$NAME" icon.highlight=on label.highlight=on
else
  sketchybar --set "$NAME" icon.highlight=off label.highlight=off
fi
