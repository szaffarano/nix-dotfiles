#!/usr/bin/env bash

set -euo pipefail

pgrep wl-paste >/dev/null && pkill wl-paste

nohup wl-paste --type text --watch safe-cliphist-store &
nohup wl-paste --type image --watch safe-cliphist-store &
