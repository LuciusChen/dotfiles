{
  keyStroke: press
  keyStrokes: send
} = hs.eventtap
_ = require 'lodash'
util = require 'util'
app = require 'app'
mouse = require 'mouse'
--screen = require 'screen'
layout = require 'layout'
bind = hs.hotkey.bind

appMap =
  a: 'com.github.atom'
  b: 'com.eusoft.freeeudic'
  c: 'com.googlecode.iterm2'
  d: 'com.jetbrains.datagrip'
  e: 'com.jetbrains.intellij'
  f: 'com.apple.finder'
  g: 'com.google.Chrome'
  h: ''
  i: ''
  j: ''
  k: ''
  l: ''
  m: ''
  n: ''
  o: ''
  p: ''
  q: 'com.bohemiancoding.sketch3'
  r: 'com.tapbots.TweetbotMac'
  s: 'com.tencent.xinWeChat'
  t: 'com.spotify.client'
  u: ''
  v: 'com.coderforart.MWeb'
  w: 'org.telegram.desktop'
  x: 'com.tencent.qq'
  y: ''
  z: 'com.readdle.PDFExpert-Mac'
  ['0']: 'com.torusknot.SourceTreeNotMAS'
  ['1']: ''
  ['2']: ''
  [',']: 'com.apple.systempreferences'
  ['.']: hs.toggleConsole
  ['[']: mouse\clickNotificationUp
  [']']: mouse\clickNotificationDown

_.forEach appMap, (v, k) ->
  if type(v) == 'function'
    bind '⌘⌃⌥', k, v
  elseif #v > 0
    bind '⌘⌃⌥', k, () -> app\toggle(v)

--blackList = util.merge(_.values(appMap), { 'com.apple.notificationcenterui', 'com.kapeli.dashdoc' })

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
  i: 'maximize'
  ['space']: 'toggle'
  k: 'minimize'
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
  ['3']: 'moveToScreen'
  ['0']: 'mouse'

_.forEach layoutMap, (v, k) ->
  if type(v) == 'function'
    bind '⌘⌃⌥⇧', k, v
  elseif #v > 0
    bind '⌘⌃⌥⇧', k, () ->
      k = tonumber(k)
      layout[v](layout, if _.isNumber(k) then k)
