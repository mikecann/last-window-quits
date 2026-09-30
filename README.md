# <img src="icons/last-window-quits.png" width="24" alt=""> last-window-quits

Close an app's last window and the app actually quits, like on Windows

macOS 13 or later

<!-- media: hero -->
<!-- ![last-window-quits](docs/hero.png) -->
<!-- media: hero -->

![A macOS-style window dissolving as its Dock icon powers down](docs/header.webp)

## What it is

On a Mac, clicking the red close button usually leaves the app running in the Dock. This small menu-bar tool quits a normal app once its last window has been closed for a second.

It tries to be careful about it. Minimised windows still count as open, Finder and friends are left alone, and it asks the app to quit the normal way so you still get any save prompts.

## Get it

Paste this into your AI coding agent (Claude Code, Codex, Cursor...):

> Clone https://github.com/mikecann/last-window-quits and make it my own. It's one of Mike
> Cann's personal tools, so read the README first, change anything specific to his
> setup to suit mine, then help me get it running.

### Or set it up by hand

You'll need macOS 13 or later, Git, and Xcode or Command Line Tools with Swift 5.10 or later. If the developer tools aren't installed, run `xcode-select --install` first. No API keys or `.env` file are needed.

```bash
git clone https://github.com/mikecann/last-window-quits.git
cd last-window-quits
bash install.sh
bash setup_mac.sh
```

`install.sh` links the command into `~/.local/bin`. You can pass another directory, for example `bash install.sh /path/to/bin`. Keep the clone in place and rerun the installer if you move it. If `~/.local/bin` isn't on your PATH, add this to `~/.zshrc`, then open a new terminal:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

`setup_mac.sh` runs the tests, builds and signs `~/Applications/Last Window Quits.app`, starts it, and installs it as a login service. It uses an Apple Development identity if one is available, otherwise an ad-hoc signature.

Grant **Last Window Quits** access in **System Settings > Privacy & Security > Accessibility**.

## Using it

Look for **LWQ** in the menu bar. `LWQ!` means Accessibility permission is still needed. Its menu lets you pause the behaviour, toggle **Start at Login**, request permission, or quit the tool.

Open a normal Dock app, then close its last window. After a second, Last Window Quits asks it to quit. Minimising that window leaves the app running.

```bash
last-window-quits restart   # rebuild and restart the staged app
last-window-quits stop      # stop the running login service
last-window-quits setup     # run tests and install the app again
last-window-quits uninstall # stop it and remove login startup and the command
```

## Safety behaviour

- An app must first have at least one window before it is armed.
- Minimised windows still count as open.
- Finder, Dock, SystemUIServer, WindowManager, loginwindow, and this tool are always ignored.
- Only normal foreground applications are monitored. Menu-bar-only and background applications are ignored.
- Quitting uses the normal macOS termination request, so an app can show its regular save confirmation or reject the quit.
- If an application's window list cannot be read, the tool does nothing to it.

## How it works

The signed Swift menu-bar app checks normal foreground applications twice per second through macOS Accessibility. Its state machine only arms an application after seeing at least one window. When that count falls to zero and remains there for one second, it asks macOS to terminate the application normally.

The staged app keeps the bundle identifier `com.mikerosoft.last-window-quits` and a stable signing requirement so rebuilding it doesn't invalidate its Accessibility permission. The same identifier is used for login startup and saved settings.

## Development

```bash
swift test
bash Tests/install-tests.sh
bash restart.sh
tail -f ~/Library/Logs/last-window-quits.log
```

Always use `restart.sh` after a Swift change so you test the staged, consistently signed app. Running the raw SwiftPM executable gives macOS a different Accessibility identity. The six Swift tests cover the quit decision engine without needing Accessibility permission. The shell checks use a temporary clone and stub scripts, so they don't start the app or change login items.

## Troubleshooting and removal

If the app doesn't quit windows as expected, check Accessibility permission, make sure the menu option is enabled, and inspect `~/Library/Logs/last-window-quits.log`.

To stop it and remove login startup and the installed command:

```bash
bash uninstall.sh
```

If you installed the command into a custom directory, pass that same directory to `uninstall.sh`. It removes the symlink only if it points to this clone. The app remains at `~/Applications/Last Window Quits.app` and can be removed manually.

For isolated build checks, `build-app.sh` accepts `LAST_WINDOW_QUITS_APP_DIR`, `LAST_WINDOW_QUITS_BUILD_CONFIGURATION`, and `LAST_WINDOW_QUITS_CODESIGN_IDENTITY`. The launch-agent installer and uninstaller also accept `LAST_WINDOW_QUITS_PLIST_DIR`. Normal installs should use the defaults: the menu's Start at Login setting expects the standard app and LaunchAgents locations.

## Icon credit

The app icon is `door_out.png` from [Mark James's famfamfam Silk icon set](https://www.famfamfam.com/lab/icons/silk/), licensed under [CC BY 2.5](https://creativecommons.org/licenses/by/2.5/). That asset keeps its original licence.

## More tools

My other tools are at [mikerosoft.app](https://mikerosoft.app).

MIT licensed.
