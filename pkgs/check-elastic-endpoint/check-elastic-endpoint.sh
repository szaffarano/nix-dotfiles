#!/usr/bin/env bash

if ! pgrep -xf "/opt/Elastic/Endpoint/elastic-endpoint run" >/dev/null; then
	notify-send \
		" Process Alert " \
		" elastic-endpoint is not running " \
		--urgency=critical
fi
