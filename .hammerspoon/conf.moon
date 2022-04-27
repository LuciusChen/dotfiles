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
  securityAgentWhiteList: {'System Preferences'}
  hyper: '⌘⌃⌥'
  hyperPlus: '⌘⌃⌥⇧'
  bind: hs.hotkey.bind
  appMap:
    w: 'com.hnc.Discord' --ru.keepcoder.Telegram
    s: 'com.tencent.xinWeChat'
    x: 'com.electron.logseq'
    e: 'com.jetbrains.intellij'
    d: 'com.jetbrains.datagrip'
    c: 'com.googlecode.iterm2'
    r: 'com.tapbots.Tweetbot3Mac'
    f: 'com.apple.finder'
    v: 'com.microsoft.VSCode'
    t: 'md.obsidian'
    g: 'com.google.Chrome'
    b: 'com.readdle.PDFExpert-Mac'
    y: 'com.spotify.client'
    h: 'com.tencent.WeWorkMac'
    n: 'com.culturedcode.ThingsMac'
    u: 'com.readdle.smartemail-Mac'
    j: 'com.seriflabs.affinitydesigner'
    m: 'com.postmanlabs.mac'
    i: 'com.ideasoncanvas.mindnode.macos'
    k: 'com.nssurge.surge-mac'
    o: 'com.captureone.captureone14'
    l: 'com.figma.Desktop'
    p: 'com.adobe.Photoshop'
  layoutMap:
    h: 'center'
    i: 'minimize'
    ['space']: 'toggle'
    k: 'maximize'
    y: 'upHalf'
    n: 'downHalf'
    g: 'leftHalf'
    j: 'rightHalf'
    t: 'leftUp'
    u: 'rightUp'
    b: 'leftDown'
    m: 'rightDown'
    ['[']: 'preScreen'
    [']']: 'nextScreen'
    ['=']: 'larger'
    ['-']: 'smaller'
  -- ['1']: 'moveToScreen'
  -- ['2']: 'moveToScreen'
  -- ['0']: 'mouse'
conf