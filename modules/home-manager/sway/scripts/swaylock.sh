#!/usr/bin/env bash

KEEP_LATESTS=20
TIMEOUT_SECS=5
DEBUG=0

function log {
  if [ "$DEBUG" -eq 1 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a /tmp/swaylock.log
  fi
}

if [ "$#" -eq 1 ]; then
  TIMEOUT_SECS=$1
fi

log "Locking screen with timeout $TIMEOUT_SECS"

temp=${XDG_CACHE_HOME:-$HOME/.cache}/swaylock
img=$temp/lock.png

[ -d "$temp" ] || mkdir -p "$temp"

log "Downloading image"

if [ "$TIMEOUT_SECS" -gt 0 ]; then
  img="$temp"/$(curl 'https://unsplash.it/1920/1080/?random' \
     -LJO -s --output-dir "$temp" --write-out '%{filename_effective}')
else
  img="$temp/$(ls -tr "$temp" | shuf -n 1)"
  log "Image downloaded: $img"
fi

ls -tr "$temp" | head -n -$KEEP_LATESTS | xargs -I {} rm "$temp"/{}

if [ "$TIMEOUT_SECS" -gt 0 ]; then
  log "Timeout set, waiting $TIMEOUT_SECS seconds"

  swayimg -s fit -f "$img" &
  PRE_PID=$!

  sleep $TIMEOUT_SECS

  if ps -p "$PRE_PID" > /dev/null 2>&1; then
    log "Timeout reached, locking"
    swaylock -i "$img"
    kill "$PRE_PID"
  else
    log "User aborted"
  fi
else
  log "No timeout, locking immediately"
  swaylock -i "$img"
fi
