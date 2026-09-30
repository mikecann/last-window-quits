#!/usr/bin/env bash
# Install the CLI launcher. setup_mac.sh builds the app and enables login startup.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$HOME/.local/bin}"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Usage: bash install.sh [target_bin_dir]"
  echo "Default: ~/.local/bin. Then run bash setup_mac.sh to install the app."
  exit 0
fi
if [[ "$#" -gt 1 || "$TARGET_DIR" == -* ]]; then
  echo "Usage: bash install.sh [target_bin_dir]" >&2
  exit 2
fi

mkdir -p "$TARGET_DIR"
chmod +x "$SCRIPT_DIR/last-window-quits"
ln -sf "$SCRIPT_DIR/last-window-quits" "$TARGET_DIR/last-window-quits"
echo "Installed $TARGET_DIR/last-window-quits -> $SCRIPT_DIR/last-window-quits"
echo "Keep this clone in place, or rerun the installer after moving it."
case ":$PATH:" in
  *":$TARGET_DIR:"*) ;;
  *) echo "Add $TARGET_DIR to PATH to use the command from your terminal." ;;
esac
echo "Run bash \"$SCRIPT_DIR/setup_mac.sh\" to build, sign and start the menu-bar app."
