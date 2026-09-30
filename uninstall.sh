#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$HOME/.local/bin}"
PLIST="${LAST_WINDOW_QUITS_PLIST_DIR:-$HOME/Library/LaunchAgents}/com.mikerosoft.last-window-quits.plist"
LAUNCHER="$TARGET_DIR/last-window-quits"

if [[ "$#" -gt 1 || "$TARGET_DIR" == -* ]]; then
  echo "Usage: bash uninstall.sh [target_bin_dir]" >&2
  exit 2
fi

bash "$SCRIPT_DIR/kill.sh"
if [[ -f "$PLIST" ]]; then
  rm "$PLIST"
fi

# Only remove the command if this clone owns it.
if [[ -L "$LAUNCHER" && "$(readlink "$LAUNCHER")" == "$SCRIPT_DIR/last-window-quits" ]]; then
  rm "$LAUNCHER"
fi

echo "Stopped Last Window Quits and removed it from login."
echo "The app remains at ${LAST_WINDOW_QUITS_APP_DIR:-$HOME/Applications/Last Window Quits.app} and can be removed manually."
