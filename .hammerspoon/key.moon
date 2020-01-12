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

-- "clipboard History" and "Emojis" dependent on "SpoonInstall"
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall\andUse('TextClipboardHistory', {config: {show_in_menubar: false}, hotkeys: {toggle_clipboard: {hyper, "1" }}, start: true})
spoon.SpoonInstall\andUse('Emojis')
spoon.Emojis\bindHotkeys({toggle: {hyper, "2" }})

-- launch center
appMap =
  a: 'com.github.atom'
  b: 'com.eusoft.freeeudic'
  c: 'com.googlecode.iterm2'
  d: 'com.jetbrains.datagrip'
  e: 'com.jetbrains.intellij'
  f: 'com.apple.finder'
  g: 'com.google.Chrome'
  h: 'com.readdle.smartemail-Mac'
  i: 'com.electron.poster'
  j: 'com.windisco.Maria'
  k: 'com.apple.Safari'
  l: 'com.adobe.LightroomClassicCC7'
  m: 'com.postmanlabs.mac'
  n: 'notion.id'
  o: 'com.tencent.wechat.devtools'
  p: 'com.adobe.Photoshop'
  q: 'com.readdle.PDFExpert-Mac'
  r: 'com.tapbots.TweetbotMac'
  s: 'com.tencent.xinWeChat'
  t: 'com.spotify.client'
  u: 'com.xk72.Charles'
  v: 'com.coderforart.MWeb'
  w: 'com.brettterpstra.marked2'
  x: 'com.tencent.qq'
  y: 'com.yummysoftware.yummy-ftp'
  z: ''
  ['8']: spotify.previous
  ['9']: spotify.playpause
  ['0']: spotify.next
  ['-']: spotify.volumeDown
  ['=']: spotify.volumeUp
  [',']: 'com.apple.systempreferences'
  ['.']: hs.toggleConsole
  ['[']: mouse\clickNotificationUp
  [']']: mouse\clickNotificationDown

_.forEach appMap, (v, k) ->
  if type(v) == 'function'
    bind '⌘⌃⌥', k, v
  elseif #v > 0
    bind '⌘⌃⌥', k, () -> app\toggle(v)

-- blackList = util.merge(_.values(appMap), { 'com.apple.notificationcenterui', 'com.kapeli.dashdoc' })

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

bind '⌘⌃⌥', 'space', hint

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
    bind '⌘⌃⌥⇧', k, v
  elseif #v > 0
    bind '⌘⌃⌥⇧', k, () ->
      k = tonumber(k)
      layout[v](layout, if _.isNumber(k) then k)
