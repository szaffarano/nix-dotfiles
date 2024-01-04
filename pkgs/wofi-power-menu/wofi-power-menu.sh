#!/usr/bin/env bash

wofi_opts=(
   -S dmenu
   -p "Power option"
   -i
   -lines 10
   -bw 1
)

declare -A power_opts
power_opts["Power off"]="systemctl poweroff"
power_opts["Reboot"]="systemctl reboot"
power_opts["Logout"]="systemctl --user start sway-session-shutdown.target; swaymsg exit"
power_opts["Hibernate"]="systemctl hibernate"
power_opts["Suspend"]="systemctl suspend"

list=$(
   for x in "${!power_opts[@]}"; do
      echo "$x"
   done | sort
)

action=$(echo "$list" | wofi "${wofi_opts[@]}")

[[ -z $action ]] && exit

cmd="${power_opts["$action"]}"

eval "$cmd"

exit 0
