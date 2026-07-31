#!/usr/bin/env bash

DEBUG=${DEBUG_TOGGLE_SCRATCHPAD:-false}

function log {
	msg=$1
	if [ "$DEBUG" = "true" ]; then
		echo "$msg" | tee -a /tmp/toggle.log
	fi
}

function die {
	msg=$1
	echo "$msg" >>/tmp/toggle.log
	echo "$msg" >&2
	exit 1
}

function usage {
	die "Usage: toggle-hyprland-scratchpad [raw|wrap] <workspace> <cmd>"
}

function main {
	[ $# -eq 3 ] || usage

	local mode="$1"
	local workspace="$2"
	local cmd="$3"

	log "Starting toggle [ mode=$mode workspace=$workspace ]"

	pid=$(hyprctl clients -j | jq ".[] | select (.class == \"$workspace\") | .pid")

	if [ -z "$pid" ]; then
		log "App on workspace [$workspace] is not running, about to launch it..."

		case "$mode" in
		wrap)
			hyprctl dispatch -- exec "[float] foot -a \"$workspace\" fish -c \"$cmd\""
			;;
		raw)
			eval "$cmd" &
			;;
		*)
			die "Unknown mode $mode"
			;;
		esac
	else
		log "App on workspace [$workspace] already  launched, toggling it"
		hyprctl dispatch togglespecialworkspace "$workspace"
	fi
}

main "$@"
