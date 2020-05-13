-- module require
conf =
  debug: true
  moudle:
    reload: true
    control: true
    layout: true
    mouse: true
    pwd: true
    keyboard: true
    wifi: false
    usb: true
    headphones: true
  hyper: {'cmd', 'alt', 'ctrl'}
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

conf
