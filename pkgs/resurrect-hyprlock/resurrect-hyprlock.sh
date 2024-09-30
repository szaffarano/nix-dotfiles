#!/usr/bin/env bash

echo "Updating misc:allow_session_lock_restore to true"
hyprctl --instance 0 'keyword misc:allow_session_lock_restore 1'

echo "Relaunching hyprlock"
hyprctl --instance 0 'dispatch exec hyprlock'

echo "Restarting hypridle"
systemctl --user restart hypridle.service
