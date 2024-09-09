#!/usr/bin/env bash

bootstrap="$(readlink -f /run/booted-system/kernel | cut -c 45- | sed s'/\/.*//g')" \
current="$(readlink -f /run/current-system/kernel | cut -c 45- | sed s'/\/.*//g')"
restart=$([ "$bootstrap" = "$current" ] && echo false || echo true)

printf '%15s %s\n%15s %s\n%15s %s\n' \
  "Booted kernel:" \
  "$bootstrap" \
  "Current kernel:" \
  "$current" \
  "Restart:" \
  "$restart"
