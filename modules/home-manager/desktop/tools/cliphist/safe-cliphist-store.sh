#!/usr/bin/env bash

[ "$CLIPBOARD_STATE" = "sensitive" ] && exit 0

cliphist store
