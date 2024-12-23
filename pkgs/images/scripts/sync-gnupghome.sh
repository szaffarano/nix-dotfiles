#!/usr/bin/env bash

set -euo pipefail

function die() {
  echo "$1"
  exit 1
}

function main() {
  if [ "$(id -u)" -eq 0 ]; then
    die "Don't run this script as root"
  fi

  if [ $# -ne 1 ]; then
    die "Usage: $0 <gnupg-backup>"
  fi

  local backup_dir=$1

  cp -avi "$backup_dir"/* "$GNUPGHOME"

  gpg -K
}

main "$@"
