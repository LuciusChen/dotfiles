## Install

```
security add-generic-password -s hammerspoon -a system -w password
brew install lua
brew install luarocks
luarocks install moonscript
luarocks install lodash
Download: https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip and put it ../Spoons/
keyboard moudle needs to config your own keyboard's sourceID
```

## Function

Karabiner-Elements:

- Change `Tab` to `cmd+alt+ctrl` if pressed with other keys
- Change `Command + Esc` to `Command + ` ` (convenient for HHKB)
- change `Esc` to `cmd+shift+ctrl` if pressed with other keys (just for convenient use)

### Launchpad

hotkey: `⌘⌃⌥` (Change to `Tab`)

- `a-z`: launch app
- `8`: previous (Spotify)
- `9`: pause (Spotify)
- `0`: next (Spotify)
- `-`: volume down (Spotify)
- `=`: volume up (Spotify)
- `[`: click Notification up
- `]`: click Notification down
- `\`: reload HammerSpoon config
- `,`: launch Systempreferences
- `.`: toggle HammerSpoon's console
- `2`: search Emoji
- `3`: search clipboard
- `Space`: show app not in config or blacklist

### Window Layout

hotkey: `⌘⌃⌥⇧` (Change to `Tab + shift`)

- `t`: leftUp
- `g`: leftHalf
- `b`: leftDown
- `y`: upHalf
- `h`: center
- `n`: downHalf
- `u`: rightUp
- `j`: rightHalf
- `m`: rightDown
- `k`: maximize
- `i`: minimize
- `space`: switch between maximize and center
- `[`: previous screen
- `]`: next screen
- `-`: smaller
- `=`: larger

Learn more from `key.moon`

### Keyboard Switch

This is just for Mother tongue is not Englist, application's Bundle identifier(Bundle ID or App ID, in info.plist) is configed will switch to ABC.