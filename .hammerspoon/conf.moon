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
  -- org.zotero.zotero
  -- com.hnc.Discord
  -- com.culturedcode.ThingsMac
  -- com.electron.logseq
  appMap:
    w: 'ru.keepcoder.Telegram' 
    s: 'com.tencent.xinWeChat'
    x: 'com.tapbots.Tweetbot3Mac'
    e: 'com.jetbrains.intellij'
    d: 'com.jetbrains.datagrip'
    c: 'com.googlecode.iterm2'
    r: 'org.gnu.Emacs'
    f: 'com.apple.finder'
    v: 'com.microsoft.VSCode'
    t: 'com.calibre-ebook.ebook-viewer'
    g: 'com.google.Chrome'
    b: 'com.readdle.PDFExpert-Mac'
    y: 'com.spotify.client'
    h: 'com.tencent.WeWorkMac'
    n: 'net.ankiweb.dtop' 
    u: 'com.readdle.smartemail-Mac'
    j: 'com.seriflabs.affinitydesigner'
    m: 'com.postmanlabs.mac'
    i: 'org.zotero.zotero'
    k: 'com.nssurge.surge-mac'
    o: 'com.captureone.captureone15'
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