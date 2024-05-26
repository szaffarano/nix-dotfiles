#!/usr/bin/env bash

bootstrap="$(readlink -f /run/booted-system/kernel)" \
current="$(readlink -f /run/current-system/kernel)"
restart=$([ "$bootstrap" = "$current" ] && echo false || echo true)

printf "Booted:\t\t%q\\nCurrent:\t%q\nRestart:\t%s\n" \
  "$bootstrap" \
  "$current" \
  "$restart"
