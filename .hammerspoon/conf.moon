-- module require
conf =
  debug: true
  moudle:
    reload: true
    control: true
    pwd: true
    keyboard: true
    wifi: true
    usb: true
    space: true
    headphones: true
  notification:
    up:
      x: 80
      y: 60
    down:
      x: 80
      y: 80
  oneTapTimeout: 0.2
  appActiveTimeout: 0.1
  appHideTimeout: 0.2
  sysEventTimeout: 0.15
  securityAgentWhiteList: {'System Preferences'}
  hyper: '⌘⌃⌥'
  hyperPlus: '⌘⌃⌥⇧'
  bind: hs.hotkey.bind
conf
