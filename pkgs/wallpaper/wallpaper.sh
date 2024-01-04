#!/usr/bin/env bash

KEEP_LATESTS=30
OFFLINE=false

if [ "$#" -eq 1 ] && [ "$1" = "-o" ]; then
  OFFLINE=true
fi

wallpapers="${XDG_PICTURES_DIR:-$HOME/Pictures}/wallpapers"

[ -d "$wallpapers" ] || mkdir -p "$wallpapers"

if [ "$OFFLINE" = false ]; then
  img="$wallpapers/$(curl 'https://unsplash.it/1920/1080/?random' \
    -LJO -s --output-dir "$wallpapers" --write-out '%{filename_effective}')"

  # shellcheck disable=SC2012
  ls -tr "$wallpapers" | head -n -$KEEP_LATESTS | xargs -I {} rm "$wallpapers"/{}
else
  img="$(find "$wallpapers" -type f | shuf -n 1)"
fi

echo -n "$(realpath "$img")"
