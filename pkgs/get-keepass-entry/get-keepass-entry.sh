#!/usr/bin/env bash

username=$1
url=$2

if [ $# -eq 2 ]; then
	printf "url=%s\nusername=%s\n" "$url" "$username" |
		git-credential-keepassxc --unlock 0 get |
		sed -n 's/^password=//p'
else
	exit 1
fi
