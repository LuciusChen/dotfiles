# Lucius's dotfiles

## zsh
- fzf
- zsh-autosuggesctions
- fzf-tab

## Kitty

``` shell
kitty +runpy 'from kitty.fast_data_types import cocoa_set_app_icon; import sys; cocoa_set_app_icon(*sys.argv[1:]); print("OK")' ~/Downloads/kitty-dark.icns
rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock
```

## HammerSpoon
![](images/Modifier-Keys.png)
[Learn more](/.hammerspoon/README.md)
