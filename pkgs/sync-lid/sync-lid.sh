#!/usr/bin/env bash

acpi_wakeup="/proc/acpi/wakeup"

function sync_lid {
  local name
  local action

  action="${1:-disable}"
  name="${2:-LID0}"

  if [ "$action" != "disable" ] && [ "$action" != "enable" ]; then
    echo "Usage sync_lid [disable|enable] [LID_NAME]"
    exit 1
  fi

  if ! grep -qw "$name" "$acpi_wakeup"; then
    echo "$name: not found in $acpi_wakeup"
    exit 1
  fi

  status=$(grep -w "$name" "$acpi_wakeup" | sed -E s'/.*\*(\w*)\s.*/\1/g')

  case "$status" in
  enabled)
    if [ "$action" = "disable" ]; then
      echo "Disabling $name"
      echo "$name" >"$acpi_wakeup"
    else
      echo "$name is already $action"
    fi
    ;;
  disabled)
    if [ "$action" = "enable" ]; then
      echo "Enabling $name"
      echo "$name" >"$acpi_wakeup"
    else
      echo "$name is already $action"
    fi
    ;;
  *)
    echo "Unknown status: $status"
    exit 1
    ;;
  esac
}

sync_lid "$@"
