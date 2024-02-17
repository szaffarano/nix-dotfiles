#!/usr/bin/env bash

acpi_wakeup="/proc/acpi/wakeup"

function disable {
  local name

  name="${1:-LID0}"

  echo "About to disable $name"

  if ! grep -qw "$name" "$acpi_wakeup"
  then
    echo "$name: not found in $acpi_wakeup"
    exit 1
  fi

  status=$(grep -w "$name" "$acpi_wakeup" | sed -E s'/.*\*(\w*)\s.*/\1/g')

  case "$status" in
    enabled)
      echo "Disabling $name"
      echo "$name" > "$acpi_wakeup"
      ;;
    disabled)
      echo "$name is already disabled"
      ;;
    *)
      echo "Unknown status: $status"
      exit 1
      ;;
  esac
}

disable "$@"
