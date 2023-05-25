#!/usr/bin/env bash

RUNNING_MUSIC=$(swaymsg -t get_tree -r | jq '.nodes[].nodes[].floating_nodes[] | select(.app_id=="music-player")')

[ -z "$RUNNING_MUSIC" ] && wezterm start --class=music-player zsh --login -c "ncspot"
