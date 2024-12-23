#!/usr/bin/env bash

set -euo pipefail

function die() {
  echo "$1"
  exit 1
}

function main() {
  if [ $# -ne 1 ]; then
    die "Usage: $0 <destination-folder>"
  fi

  [ -d "$1" ] || die "$1 not found"

  local output
  local keyid

  keyid=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')
  output="$1/gnupg-$keyid-$(date +%Y-%m-%d)"

  [ -d "$output" ] && die "$output already exists"

  sudo mkdir -p "$output"
  sudo chown "$(id -u):$(id -g)" "$output"
  sudo chmod 700 "$output"
  sudo cp -avi "$GNUPGHOME"/* "$output"
}

main "$@"
