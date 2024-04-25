#!/usr/bin/env bash

DEBUG=false

function log {
  msg=$1
  if [ "$DEBUG" = "true" ]; then
    echo "$msg" | tee -a /tmp/toggle.log
  fi
}

function die {
  msg=$1
  echo "$msg" >&2
  echo "$msg" | tee -a /tmp/toggle.log
  exit 1
}

function find_pid {
  local retries=10
  local workspace="$1"
  while ((retries > 0)); do
    pid=$(hyprctl clients -j | jq ".[] | select (.class == \"$workspace\") | .pid")
    if [ -n "$pid" ]; then
      echo -n "$pid"
      break
    fi
    sleep .5
    retries=$((retries - 1))
  done
}

function main {
  local mode="$1"
  local workspace="$2"
  local cmd="$3"

  log "Starting toggle [ mode=$mode workspace=$workspace ]"

  pid=$(hyprctl clients -j | jq ".[] | select (.class == \"$workspace\") | .pid")

  if [ -z "$pid" ]; then
    log "App is not running, about to launch it..."

    case "$mode" in
    wrap)
      nohup wezterm start --class="$workspace" zsh --login -c "$cmd" &
      ;;
    raw)
      eval "$cmd" &
      ;;
    *)
      log "Unknown mode $mode"
      ;;
    esac

    pid=$(find_pid "$workspace")
    if [ -z "$pid" ]; then
      die "Error getting pid for $workspace"
    fi

    log "Moving $pid to workspace special"
    hyprctl dispatch movetoworkspacesilent special:"$workspace",pid:"$pid"
  else
    log "Toggle workspace $workspace"
    hyprctl dispatch togglespecialworkspace "$workspace"
  fi
}

main "$@"
