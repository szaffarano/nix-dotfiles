#!/usr/bin/env bash

bootstrap="$(readlink -f /run/booted-system/kernel | cut -c 45- | sed s'/\/.*//g')" \
current="$(readlink -f /run/current-system/kernel | cut -c 45- | sed s'/\/.*//g')"
restart=$([ "$bootstrap" = "$current" ] && echo false || echo true)

echo -e "
Booted kernel:\t$bootstrap
Current kernel:\t$current
Restart:\t$restart" | column -t -Cright -Cleft -s$'\t' -o' '
