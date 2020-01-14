{
  keyStroke: press
  keyStrokes: send
} = hs.eventtap
_ = require 'lodash'
util = require 'util'
app = require 'app'
mouse = require 'mouse'
spotify  = require 'hs.spotify'
layout = require 'layout'
bind = hs.hotkey.bind
hyper = '⌘⌃⌥'
hyperPlus = '⌘⌃⌥⇧'

-- "clipboard History" and "Emojis" dependent on "SpoonInstall"
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall\andUse('TextClipboardHistory', {config: {show_in_menubar: false}, hotkeys: {toggle_clipboard: {hyper, "1" }}, start: true})
spoon.SpoonInstall\andUse('Emojis')
spoon.Emojis\bindHotkeys({toggle: {hyper, "2" }})

-- launch center
-- layout for memory
appMap =
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
  r: 'com.tapbots.TweetbotMac'
  f: 'com.apple.finder'
  v: 'com.microsoft.VSCode'
  t: 'com.culturedcode.ThingsMac'
  g: 'com.google.Chrome'
  b: 'com.readdle.PDFExpert-Mac'
  y: 'com.spotify.client'
  h: ''
  n: 'notion.id'
  u: ''
  j: ''
  m: 'com.postmanlabs.mac'
  i: 'com.electron.poster'
  k: 'com.apple.Safari'
  o: ''
  l: 'com.adobe.LightroomClassicCC7'
  p: 'com.adobe.Photoshop'
  ['[']: mouse\clickNotificationUp
  [']']: mouse\clickNotificationDown
  ['\\']: util\reload
  [',']: 'com.apple.systempreferences'
  ['.']: hs.toggleConsole

_.forEach appMap, (v, k) ->
  if type(v) == 'function'
    bind hyper, k, v
  elseif #v > 0
    bind hyper, k, () -> app\toggle(v)

-- blackList
blackList = util.merge(_.values(appMap), { 'com.adobe.acc.AdobeCreativeCloud' })

hint = () ->
  wins = {}
  _.forEach hs.application.runningApplications!, (v) ->
    name = v\name!
    id = v\bundleID!
    win = v\allWindows!
    if #win > 0 and not _.some(appMap, (v, k) -> v == id) and not _.includes(blackList, id)
      _.forEach win, (v) ->
        _.push wins, v
  hs.hints.windowHints(wins, nil, true)

bind hyper, 'space', hint

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
