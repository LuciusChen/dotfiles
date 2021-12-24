{
  keyStroke: press
  keyStrokes: send
} = hs.eventtap

_ = require 'lodash'
util = require 'util'
mouse = require 'mouse'
conf = require 'conf'
spotify  = require 'hs.spotify'
layout = require 'layout'
keybindings = require 'keybindings'
keybindings\init!

-- launch center
powerMap =
  ['7']: mouse\mouseHighlight
  ['8']: spotify.previous
  ['9']: spotify.playpause
  ['0']: spotify.next
  ['-']: spotify.volumeDown
  ['=']: spotify.volumeUp
  ['[']: mouse\clickNotificationUp
  [']']: mouse\clickNotificationDown
  ['\\']: util\reload
  [',']: 'com.apple.systempreferences'
  ['.']: hs.toggleConsole
  ['delete']: hs.caffeinate.lockScreen
  ['/']: keybindings\toggle

-- This implicitly passes util as self to the actual function, and now util will contain the actual argument.
appMap = util\tableMerge(conf.appMap, powerMap)

_.forEach appMap, (v, k) ->
  if type(v) == 'function'
    conf.bind conf.hyper, k, v
  elseif #v > 0
    conf.bind conf.hyper, k, () -> util\toggle(v)

-- blacklist
blacklist = util.merge(_.values(appMap), {
  'org.hammerspoon.Hammerspoon',  
  'com.apple.notificationcenterui'
  })

-- hs.hints.windowHints is too slow
createWindowChooser = () ->
  chooser = hs.chooser.new (choice) ->
    if choice != nil
      window = hs.window.get choice["id"]
      window\focus!

  conf.bind conf.hyper, 'space', () ->
    windows = {}
    wf = hs.window.filter.new()

    _.forEach wf\getWindows!, (v) ->
      id = v\application()\bundleID!
      if not _.some(appMap, (value, key) -> value == id) and not _.includes(blacklist, id)
        table.insert(windows, {
          ["text"]: v\application()\name!,
          ["subText"]: v\title!,
          ["bundleID"]: v\application()\bundleID!,
          ["id"]: v\id!,
        })
    if windows != {}
      chooser\choices windows
      chooser\show()

createWindowChooser()


-- if some apps are running, but no windows - force create one
-- callback = (win) ->
--   appToLaunch = win\application!
--   if appToLaunch\findWindow! == nil
--     hs.application.launchOrFocusByBundleID appToLaunch\bundleID!
--     layout\maximize! if maximize
--     mouse\frontmost!

-- hs.window._timed_allWindows() for ping
-- hint = () ->
--   wins = {}
--   _.forEach hs.application.runningApplications!, (v) ->
--     name = v\name!
--     id = v\bundleID!
--     win = v\allWindows!
--     if #win > 0 and not _.some(appMap, (v, k) -> v == id) and not _.includes(blacklist, id)
--       _.forEach win, (v) ->
--         _.push wins, v
--   hs.hints.windowHints(wins, callback, true)

-- bind hyper, 'space', hint

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
  -- ['1']: 'moveToScreen'
  -- ['2']: 'moveToScreen'
  -- ['0']: 'mouse'

_.forEach layoutMap, (v, k) ->
  if type(v) == 'function'
    conf.bind conf.hyperPlus, k, v
  elseif #v > 0
    conf.bind conf.hyperPlus, k, () ->
      k = tonumber(k)
      layout[v](layout, if _.isNumber(k) then k)
