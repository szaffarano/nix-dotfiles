#!/usr/bin/env bash

bootstrap="$(readlink -f /run/booted-system/kernel | cut -c 45- | sed s'/\/.*//g')" \
current="$(readlink -f /run/current-system/kernel | cut -c 45- | sed s'/\/.*//g')"
restart=$([ "$bootstrap" = "$current" ] && echo false || echo true)

printf '%s\t%s\n%s\t%s\n%s\t%s\n' \
	"Booted kernel:" \
	"$bootstrap" \
	"Current kernel:" \
	"$current" \
	"Restart:" \
	"$restart" | column -t -Cright -Cleft -s$'\t' -o' '
