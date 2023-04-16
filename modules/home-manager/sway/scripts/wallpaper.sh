#!/usr/bin/env bash

KEEP_LATESTS=10

wallpapers="${XDG_PICTURES_DIR:-$HOME/Pictures}/wallpapers"

[ -d "$wallpapers" ] || mkdir -p "$wallpapers"

img="$temp"/$(curl 'https://unsplash.it/1920/1080/?random' \
  -LJO -s --output-dir "$wallpapers" --write-out '%{filename_effective}')

ls -tr "$wallpapers" | head -n -$KEEP_LATESTS | xargs -I {} rm "$wallpapers"/{}

echo -n $(realpath "$wallpapers/$img")
