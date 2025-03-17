#!/usr/bin/env bash

RETRIES=10

function main() {
	[ $# -eq 2 ] || die

	APP_ID="$1"
	CMD="$2"

	running "$APP_ID" || (launch "$APP_ID" "$CMD" && wait_for "$APP_ID")
	toggle "$APP_ID"
}

function launch() {
	eval "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | "W=" + (.current_mode.width|tostring) + " H=" + (.current_mode.height|tostring)')"
	WIDTH=$((W * 75 / 100))
	HEIGHT=$((H * 75 / 100))

	nohup foot -w "${WIDTH}x${HEIGHT}" -a "$1" fish -c "$2" >/dev/null 2>&1 &
}

function running() {
	swaymsg -t get_tree -r |
		jq ".nodes[].nodes[].floating_nodes[] | select(.app_id==\"$1\")" |
		(grep -q "id" && true) || false
}

function wait_for() {
	local COUNT=0
	while ! running "$1" && [ "$COUNT" -lt "$RETRIES" ]; do
		COUNT=$((COUNT + 1))
		sleep .1
	done
}

function toggle() {
	sway "[app_id=$1]" "scratchpad show; move position center"
}

function die() {
	echo "Usage: $(basename "${BASH_SOURCE[1]}") <app-id> <command>"
	exit 1
}

main "$@"
