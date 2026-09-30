# Agent guidance for last-window-quits

This repo contains a macOS 13+ Swift menu-bar app. Source, scripts, icons and tests live here; installers must work from this clone without another checkout.

## Rules

- Use test-first development for non-trivial behaviour changes. If there is no clean test seam, extract one first.
- When behaviour, UI copy, persistence, startup or a tested contract changes, update the relevant tests and rerun them after implementing the change.
- Test before committing: run `swift test`, `bash Tests/install-tests.sh`, and shell syntax checks. Then smoke-test the staged app when the environment permits it. Report permission or hardware checks you could not perform.
- Keep generated binaries and app bundles out of Git. Swift output belongs in `.build/`.
- Write plain, friendly documentation without em dashes or en dashes. PR descriptions start with `## Why` and explain what prompted the change.

## Development and installation

The original agent guidance had no tool-specific section for this app. These details come from its existing scripts and README.

```bash
swift test
bash Tests/install-tests.sh
bash restart.sh
tail -f ~/Library/Logs/last-window-quits.log
```

- Always use `restart.sh` after Swift changes. It builds, signs and stages `~/Applications/Last Window Quits.app`, then replaces the login service. Test Accessibility using that bundle, not the raw SwiftPM executable.
- Preserve `com.mikerosoft.last-window-quits`, the signing requirement, settings keys and log paths so existing installs keep their identity and permissions.
- `install.sh [target_bin_dir]` links the launcher into `~/.local/bin` by default. `setup_mac.sh` runs tests and installs the app and login service. Paths must be relative to the repo's own script directory, including when the launcher is invoked through a symlink.
- `uninstall.sh [target_bin_dir]` stops this service and removes this tool's plist and owned launcher symlink. It leaves the app bundle for manual removal and must preserve other tools and other clones' commands.
- CI must stay independent of Accessibility permissions, login services and signing certificates. Existing Swift tests exercise pure quit-decision logic.

## Safety contracts

Keep the one-second grace period, first-window arming, minimised-window counting, normal quit requests, ignored system apps and safe handling of unreadable Accessibility window lists. Never force-kill monitored apps.
