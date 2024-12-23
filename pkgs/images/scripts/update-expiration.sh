#!/usr/bin/env bash

set -euo pipefail

function die() {
  echo "$1"
  exit 1
}

function create_dir() {
  [ -d "$1" ] || mkdir -p "$1"
}

function main() {
  if [ "$(id -u)" -eq 0 ]; then
    die "Don't run this script as root"
  fi

  if [ $# -ne 1 ]; then
    die "Usage: $0 <expiration>"
  fi
  local expiration=$1
  local keyid
  local keyfp
  local output

  keyid=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^pub:/ { print $5; exit }')
  keyfp=$(gpg -k --with-colons "$IDENTITY" | awk -F: '/^fpr:/ { print $10; exit }')

  echo "KEYID=$keyid"
  echo "KEYFP=$keyfp"

  gpg -K
  echo "About to update GPG expiration time"

  output="/tmp/$keyid-$(date +%F).asc"
  mapfile -a args < <(gpg -K --with-colons | awk -F: '/^fpr:/ { print $10 }' | tail -n "+2" | tr "\n" " ")
  echo "$CERTIFY_PASS" | gpg --batch --pinentry-mode=loopback \
    --passphrase-fd 0 --quick-set-expire "$keyfp" "$expiration" \
    "${args[@]}"
  gpg -K
  gpg --armor --export "$keyid" | tee "$output"
  echo "Updated public key saved on $output"
}

main "$@"
