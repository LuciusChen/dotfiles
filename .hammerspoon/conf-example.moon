conf =
  moudle:
    reload: true
    karabiner: true
    hotkey: true
    app: true
  karabiner:
    path: '~/.config/karabiner/karabiner.json'
    cmd: "'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --copy-current-profile-to-system-default-profile"
  app:
    allowOutside: false

conf
