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

function find_pid {
	local retries=20
	local workspace="$1"
	while ((retries > 0)); do
		pid=$(hyprctl clients -j | jq ".[] | select (.class == \"$workspace\") | .pid")
		if [ -n "$pid" ]; then
			echo -n "$pid"
			break
		fi
		sleep .1
		retries=$((retries - 1))
	done
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
			hyprctl dispatch -- exec "[float] foot -a \"$workspace\" zsh --login -c \"$cmd\""
			;;
		raw)
			eval "$cmd" &
			;;
		*)
			die "Unknown mode $mode"
			;;
		esac

		pid=$(find_pid "$workspace")
		if [ -z "$pid" ]; then
			die "Error getting pid for $workspace"
		fi

		log "Moving $pid to workspace special"
		hyprctl dispatch movetoworkspace special:"$workspace",pid:"$pid"
	else
		log "App on workspace [$workspace] already  launched, toggling it"
		hyprctl dispatch togglespecialworkspace "$workspace"
	fi
}

main "$@"
