#!/usr/bin/env bash

RUNNING_ORG=$(swaymsg -t get_tree -r | jq '.nodes[].nodes[].floating_nodes[] | select(.app_id=="org-mode")')

[ -z "$RUNNING_ORG" ] && wezterm start --class=org-mode zsh --login -c "vim +WikiIndex"
