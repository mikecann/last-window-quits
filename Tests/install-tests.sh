#!/usr/bin/env bash
# Exercise the installed launcher without changing login items or running the app.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT
REPO="$TEST_DIR/clone with spaces"
BIN="$TEST_DIR/bin with spaces"
mkdir -p "$REPO"
cp "$ROOT/last-window-quits" "$ROOT/install.sh" "$ROOT/uninstall.sh" "$REPO/"

cat >"$REPO/restart.sh" <<'SCRIPT'
#!/usr/bin/env bash
echo "restart reached"
SCRIPT
cat >"$REPO/kill.sh" <<'SCRIPT'
#!/usr/bin/env bash
exit 0
SCRIPT
chmod +x "$REPO/restart.sh" "$REPO/kill.sh"

bash "$REPO/install.sh" "$BIN"
bash "$REPO/install.sh" "$BIN"
[[ "$(readlink "$BIN/last-window-quits")" == "$REPO/last-window-quits" ]]
[[ "$("$BIN/last-window-quits" start)" == "restart reached" ]]
[[ "$(PATH="$BIN:$PATH" last-window-quits start)" == "restart reached" ]]

# Relative symlinks should find the clone too.
ln -s "../clone with spaces/last-window-quits" "$BIN/relative-launcher"
[[ "$("$BIN/relative-launcher" start)" == "restart reached" ]]

# Keep login-item removal in this temporary directory too.
mkdir -p "$TEST_DIR/agents"
touch "$TEST_DIR/agents/com.mikerosoft.last-window-quits.plist"
touch "$TEST_DIR/agents/another-tool.plist"
LAST_WINDOW_QUITS_PLIST_DIR="$TEST_DIR/agents" bash "$REPO/uninstall.sh" "$BIN"
[[ ! -L "$BIN/last-window-quits" ]]
[[ ! -f "$TEST_DIR/agents/com.mikerosoft.last-window-quits.plist" ]]
[[ -f "$TEST_DIR/agents/another-tool.plist" ]]

# Uninstall must preserve a command owned by another clone.
ln -s "$TEST_DIR/another-clone/last-window-quits" "$BIN/last-window-quits"
LAST_WINDOW_QUITS_PLIST_DIR="$TEST_DIR/agents" bash "$REPO/uninstall.sh" "$BIN"
[[ "$(readlink "$BIN/last-window-quits")" == "$TEST_DIR/another-clone/last-window-quits" ]]
echo "Installer and symlink launcher checks passed."
