#!/usr/bin/env bash

RETRIES=10
APP_ID="org-mode"

function running() {
  RET=$(swaymsg -t get_tree -r | jq ".nodes[].nodes[].floating_nodes[] | select(.app_id==\"$1\")")
  echo -n "$RET"
}

[ -z "$(running $APP_ID)" ] && nohup wezterm start --class=org-mode zsh --login -c "vim +WikiIndex" > /dev/null 2>&1 &

COUNT=0
while [ -z "$(running $APP_ID)" ] && [ "$COUNT" -lt "$RETRIES" ]; do
  COUNT=$((COUNT+1))
  sleep .1
done

sway [app_id="$APP_ID"] scratchpad show
