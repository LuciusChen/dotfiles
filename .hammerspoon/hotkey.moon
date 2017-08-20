conf = require 'conf'
_ = require 'moses'
mouse = require 'mouse'
layout = require 'layout'
util = require 'util'
app = require 'app'
bind = hs.hotkey.bind
apps = {}
lcagList =
  a: 'com.github.atom'
  b: 'com.eusoft.freeeudic'
  c: 'com.googlecode.iterm2'
  d: 'com.jetbrains.datagrip'
  e: 'com.jetbrains.intellij'
  f: 'com.apple.finder'
  g: 'com.google.Chrome'
  h: layout\leftHalf
  i: ''
  j: layout\downHalf
  k: layout\upHalf
  l: layout\rightHalf
  m: layout\max
  n: layout\center
  o: ''
  p: ''
  q: ''
  r: 'com.tapbots.TweetbotMac'
  s: 'com.tencent.xinWeChat'
  t: 'com.spotify.client'
  u: ''
  v: 'com.coderforart.MWeb'
  w: 'ru.keepcoder.Telegram'
  x: 'com.tencent.qq'
  y: ''
  z: ''
  ['0']: ''
  ['1']: ''
  ['2']: ''
  [',']: 'com.apple.systempreferences'
  ['/']: -> hs.openConsole true
  [';']: mouse\clickNotificationUp
  ['\'']: mouse\clickNotificationDown
  tab: layout\screen
  escape: ''
  up: ''
  down: ''
for k, v in pairs lcagList
  if type(v) == 'function'
    bind conf.lcag, k, v
  elseif #v > 0
    bind conf.lcag, k, app.toggleByBundleID(v)
    _.push apps, v

_.push apps, 'com.apple.notificationcenterui'

hs.hotkey.bind('', 'f9', nil, () ->
  wins = {}
  items = _.each hs.application.runningApplications!, (k, v) ->
    name = v\name!
    id = v\bundleID!
    win = v\allWindows!
    if #win > 0 and not _.include(apps, id)
      _.each win, (k, v) ->
        _.push wins, v
  -- print hs.inspect(wins)
  hs.hints.windowHints(wins, nil, true))
