{
  keyStroke: press
  keyStrokes: send
} = hs.eventtap
_ = require 'lodash'
util = require 'util'
mouse = require 'mouse'
spotify  = require 'hs.spotify'
layout = require 'layout'
bind = hs.hotkey.bind
hyper = '⌘⌃⌥'
hyperPlus = '⌘⌃⌥⇧'

-- "clipboard History" and "Emojis" dependent on "SpoonInstall"
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall\andUse('TextClipboardHistory', {config: {show_in_menubar: false}, hotkeys: {toggle_clipboard: {hyper, "3" }}, start: true})
spoon.SpoonInstall\andUse('Emojis')
spoon.Emojis\bindHotkeys({toggle: {hyper, "2" }})

-- launch center
appMap =
  ['7']: mouse\mouseHighlight
  ['8']: spotify.previous
  ['9']: spotify.playpause
  ['0']: spotify.next
  ['-']: spotify.volumeDown
  ['=']: spotify.volumeUp
  q: ''
  a: ''
  z: ''
  w: 'ru.keepcoder.Telegram'
  s: 'com.tencent.xinWeChat'
  x: 'com.tencent.qq'
  e: 'com.jetbrains.intellij'
  d: 'com.jetbrains.datagrip'
  c: 'com.googlecode.iterm2'
  r: 'com.tapbots.Tweetbot3Mac'
  f: 'com.apple.finder'
  v: 'com.microsoft.VSCode'
  t: 'com.culturedcode.ThingsMac'
  g: 'com.google.Chrome'
  b: 'com.readdle.PDFExpert-Mac'
  y: 'com.spotify.client'
  h: 'com.tencent.WeWorkMac'
  n: 'net.shinyfrog.bear'
  u: 'com.readdle.smartemail-Mac'
  j: 'com.seriflabs.affinitydesigner'
  m: 'com.postmanlabs.mac'
  i: ''
  k: 'com.nssurge.surge-mac'
  o: 'com.captureone.captureone13'
  l: ''
  p: 'com.adobe.Photoshop'
  ['[']: mouse\clickNotificationUp
  [']']: mouse\clickNotificationDown
  ['\\']: util\reload
  [',']: 'com.apple.systempreferences'
  ['.']: hs.toggleConsole
  ['delete']: hs.caffeinate.lockScreen
  ['/']: mouse\moveToNextScreen

_.forEach appMap, (v, k) ->
  if type(v) == 'function'
    bind hyper, k, v
  elseif #v > 0
    bind hyper, k, () -> util\toggle(v)

-- blacklist
blacklist = util.merge(_.values(appMap), {})

-- if some apps are running, but no windows - force create one
callback = (win) ->
  appToLaunch = win\application!
  if appToLaunch\findWindow! == nil
    hs.application.launchOrFocusByBundleID appToLaunch\bundleID!
    layout\maximize! if maximize
    mouse\frontmost!

hint = () ->
  wins = {}
  _.forEach hs.application.runningApplications!, (v) ->
    name = v\name!
    id = v\bundleID!
    win = v\allWindows!
    if #win > 0 and not _.some(appMap, (v, k) -> v == id) and not _.includes(blacklist, id)
      _.forEach win, (v) ->
        _.push wins, v
  hs.hints.windowHints(wins, callback, true)

bind hyper, 'space', hint

-- Set Window Position on screen
layoutMap =
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
  ['1']: 'moveToScreen'
  ['2']: 'moveToScreen'
  ['0']: 'mouse'

_.forEach layoutMap, (v, k) ->
  if type(v) == 'function'
    bind hyperPlus, k, v
  elseif #v > 0
    bind hyperPlus, k, () ->
      k = tonumber(k)
      layout[v](layout, if _.isNumber(k) then k)

