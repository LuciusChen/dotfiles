_ = require 'lodash'
layout = require 'layout'
mouse = require 'mouse'
app = require 'app'
--hs.hotkey.modal.new(mods, key, message) -> hs.hotkey.modal object
layoutLayer = hs.hotkey.modal.new()
-- hs.hotkey.bind '', 'f14', layoutLayer\enter, layoutLayer\exit
-- layoutLayer.entered = -> _.print 'enterd'
-- layoutLayer.exited = -> _.print 'exited'
layoutKeymap =
  s: 'center'
  r: 'maximize'
  ['space']: 'toggle'
  f: 'minimize'
  w: 'upHalf'
  x: 'downHalf'
  a: 'leftHalf'
  d: 'rightHalf'
  q: 'leftUp'
  e: 'rightUp'
  z: 'leftDown'
  c: 'rightDown'
  up: 'northScreen'
  down: 'southScreen'
  left: 'westScreen'
  right: 'eastScreen'
  ['[']: 'preScreen'
  [']']: 'nextScreen'
  ['=']: 'larger'
  ['-']: 'smaller'
  ['1']: 'moveToScreen'
  ['2']: 'moveToScreen'
  ['3']: 'moveToScreen'
_.forEach layoutKeymap, (v, k) ->
  layoutLayer\bind 'tab', k, ->
    k = tonumber(k)
    layout[v] layout, if _.isNumber(k) then k
    mouse.center!

appLayer = hs.hotkey.modal.new()
-- hs.hotkey.bind '', 'f13', appLayer\enter, appLayer\exit
appKeymap =
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
  ['.']: hs.toggleConsole
_.forEach appKeymap, (v, k) ->
  if type(v) == 'function'
    appLayer\bind 'cmd-alt-ctrl', k, v
  elseif v and #v > 0
    appLayer\bind 'cmd-alt-ctrl', k, -> app\toggle(v)
    appLayer\bind 'shift', k, -> app\toggle(v, true)

layer =
  layout: layoutLayer
  app: appLayer

layer
