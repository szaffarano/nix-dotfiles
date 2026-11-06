#!/usr/bin/env bash
set -euo pipefail

CACHE="szaffarano"
SYSTEM=/run/current-system

BLACKLIST=(
	intellij-idea
)

nh os switch --ask "$@"

all=$(nix path-info --recursive "$SYSTEM" | sort -u)

pattern=$(
	IFS='|'
	echo "${BLACKLIST[*]}"
)
blocked=$(echo "$all" | grep -E "$pattern" || true)

if [ -n "$blocked" ]; then
	tainted=$(echo "$blocked" | xargs nix-store --query --referrers-closure | sort -u)
	push=$(comm -23 <(echo "$all") <(echo "$tainted"))
else
	push=$all
fi

echo "$push" | cachix push "$CACHE"
