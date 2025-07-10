#!/usr/bin/env bash

TIMEOUT_SECS=5
NUMBER_RE='^[0-9]+$'

function log() {
	if [ -n "${DEBUG_LOCK_SCREEN:-}" ]; then
		echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$HOME/.cache/swaylock.log"
	fi
}

if [ "$#" -eq 1 ]; then
	TIMEOUT_SECS=$1
fi

if ! [[ $TIMEOUT_SECS =~ $NUMBER_RE ]]; then
	echo 'error: "TIMEOUT_SECS" Not a number' >&2
	exit 1
fi

log "Locking screen with timeout $TIMEOUT_SECS"

if [ "$TIMEOUT_SECS" -gt 0 ]; then
	img="$(wallpaper)"
	log "Image to set [on line]: $img"
else
	# -o=offline, avoid delay to lock inmediatelly
	img="$(wallpaper -o)"
	log "Image to set [off line]: $img"
fi

if [ "$TIMEOUT_SECS" -gt 0 ]; then
	log "Timeout set, waiting $TIMEOUT_SECS seconds"

	swayimg -s fit -f "$img" &
	PRE_PID=$!

	sleep "$TIMEOUT_SECS"

	if ps -p "$PRE_PID" >/dev/null 2>&1; then
		log "Timeout reached, locking"
		kill "$PRE_PID"
		swaylock -i "$img" --daemonize
	else
		log "User aborted (process \"$PRE_PID\" not running)"
	fi
else
	log "No timeout, locking immediately"
	swaylock -i "$img" --daemonize
fi
