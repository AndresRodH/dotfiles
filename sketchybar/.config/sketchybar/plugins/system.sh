#!/usr/bin/env sh

# RAM usage — parse "System-wide memory free percentage" from memory_pressure
mem_line="$(memory_pressure 2>/dev/null | grep 'System-wide memory free percentage')"
if [ -n "$mem_line" ]; then
  free_pct="$(echo "$mem_line" | sed 's/.*: \([0-9]*\)%.*/\1/')"
  ram_pct=$((100 - free_pct))
else
  ram_pct="?"
fi

# CPU usage: user + system, i.e. total CPU busy time.
cpu_line="$(top -l 1 -n 0 2>/dev/null | grep 'CPU usage')"
if [ -n "$cpu_line" ]; then
  user_pct="$(echo "$cpu_line" | sed -n 's/.*: \([0-9.]*\)% user.*/\1/p')"
  system_pct="$(echo "$cpu_line" | sed -n 's/.*% user, \([0-9.]*\)% sys.*/\1/p')"
  cpu_pct="$(awk -v user="$user_pct" -v system="$system_pct" 'BEGIN { printf "%.0f", user + system }')"
else
  cpu_pct="?"
fi

sketchybar --set cpu label="${cpu_pct}%"
sketchybar --set ram label="${ram_pct}%"
