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
	local encrypted_mount_point="/mnt/encrypted-storage"
	local public_mount_point="/mnt/public"
	local mapper_name="gnupg-secrets"

	if [ "$(id -u)" -ne 0 ]; then
		die "This script must be run as root"
	fi

	if [ $# -ne 2 ]; then
		die "Usage: $0 <encrypted-device> <public-device>"
	fi

	encrypted_device=$1
	public_device=$2

	[ -b "$encrypted_device" ] || die "Device $encrypted_device does not exist"
	[ -b "$public_device" ] || die "Device $public_device does not exist"

	create_dir "$encrypted_mount_point"
	create_dir "$public_mount_point"

	[ -b /dev/mapper/$mapper_name ] || cryptsetup luksOpen "$encrypted_device" $mapper_name

	mount /dev/mapper/$mapper_name $encrypted_mount_point
	mount "$public_device" $public_mount_point
}

main "$@"
