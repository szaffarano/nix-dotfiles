#!/usr/bin/env bash

set -euo pipefail

if ! pgrep -xf "/opt/Elastic/Endpoint/elastic-endpoint run" >/dev/null; then
	notify-send \
		" Process Alert " \
		" elastic-endpoint is not running " \
		--urgency=critical
fi
