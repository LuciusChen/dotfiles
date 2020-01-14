## Install

1. `security add-generic-password -s hammerspoon -a system -w password` (password change to your own password)
2. brew install lua
3. brew install luarocks
4. luarocks install moonscript
5. luarocks install lodash
6. Download [SpoonInstall](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip) and put it ../Spoons/
7. keyboard moudle needs to config your own keyboard's sourceID


## Function

Karabiner-Elements:

- Change `Tab` to `cmd+alt+ctrl` if pressed with other keys
- Change `Command + Esc` to `Command + ` ` (convenient for HHKB)
- change `Esc` to `cmd+shift+ctrl` if pressed with other keys (just for convenient use)

### Launchpad

hotkey: `⌘⌃⌥` (Change to `Tab`)

- `a-z` : launch app
- `8` : previous (Spotify)
- `9` : pause (Spotify)
- `0` : next (Spotify)
- `-` : volume down (Spotify)
- `=` : volume up (Spotify)
- `[` : click Notification up
- `]` : click Notification down
- `\` : reload HammerSpoon config
- `,` : launch Systempreferences
- `.` : toggle HammerSpoon's console
- `2` : search Emoji
- `3` : search clipboard
- `Space` : show app not in config or blacklist

### Window Layout

hotkey: `⌘⌃⌥⇧` (Change to `Tab + shift`)

- `t` : leftUp
- `g` : leftHalf
- `b` : leftDown
- `y` : upHalf
- `h` : center
- `n` : downHalf
- `u` : rightUp
- `j` : rightHalf
- `m` : rightDown
- `k` : maximize
- `i` : minimize
- `space` : switch between maximize and center
- `[` : previous screen
- `]` : next screen
- `-` : smaller
- `=` : larger

Learn more from `key.moon`

### Keyboard Switch

This is just for Mother tongue is not English, application's Bundle identifier(Bundle ID or App ID, in info.plist) is configed will switch to ABC.