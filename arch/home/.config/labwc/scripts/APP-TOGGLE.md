# Labwc app-toggle convention

All `Super + letter` application shortcuts should use `app-toggle`:

```xml
<keybind key="W-x" onRelease="yes">
  <action name="Execute"
          command="~/.config/labwc/scripts/app-toggle APP_ID LAUNCH_COMMAND" />
</keybind>
```

Behavior is shared by every configured application:

1. If its window is focused, minimize it without moving the cursor.
2. If its window exists, unminimize/focus it and warp the cursor to the
   center of that window, including when it is on another output.
3. If no matching window exists, run `LAUNCH_COMMAND`.

`APP_ID` must be the identifier shown by `wlrctl window list`. The helper also
accepts versioned identifiers beginning with `APP_ID-`, such as
`emacs-32-0-50` for `APP_ID=emacs`.

The private `Super+Ctrl+Alt+Shift+P` binding in `rc.xml` is an implementation
detail used to ask Labwc to perform the absolute cursor warp.
