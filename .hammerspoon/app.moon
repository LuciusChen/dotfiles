mouse = require 'mouse'
util = require 'util'
conf = require 'conf'
layout = require 'layout'

-- Tap into input events (mouse, keyboard, trackpad) for observation
-- and possibly overriding them It also provides convenience wrappers
-- for sending mouse and keyboard events. If you need to construct finely
-- controlled mouse/keyboard events, see hs.eventtap.event
-- http://www.hammerspoon.org/docs/hs.eventtap.html

{
  keyStroke: press
  keyStrokes: send
} = hs.eventtap

toggle = false
app =
  toggle: (id, maximize) =>
    toggle = true
    app = hs.application.frontmostApplication!
    if app\bundleID! == id
      app\hide!
    else
      hs.application.launchOrFocusByBundleID id
      layout\maximize! if maximize

-- below not using
posTable = {}
lastName = nil
hs.application.watcher.new((name, event, app) ->
  eventName = nil
  switch event
    when hs.application.watcher.activated
      eventName = 'activated'
    when hs.application.watcher.terminated
      eventName = 'terminated'
    when hs.application.watcher.deactivated
      unless name
        return
      eventName = 'deactivated'
    when hs.application.watcher.hidden
      eventName = 'hidden'
      return
    when hs.application.watcher.unhidden
      eventName = 'unhidden'
      return
    when hs.application.watcher.launched
      eventName = 'launched'
      return
    when hs.application.watcher.launching
      eventName = 'launching'
      return
  -- if lastName == 'SecurityAgent' and util\checkSecurityAgent! == '1'
  --   send util\getSysPwd!
  --   if _.includes({'系统偏好设置'}, name)
  --     press {}, 'return'
  if eventName == 'activated' and eventName == 'unhidden'
    lastName = name
  else
    posTable[tostring(name)] = hs.mouse.getAbsolutePosition!
    pos = posTable[tostring(lastName)]
    win = layout\win!
    frame = win\frame!
    if toggle
      hs.mouse.setAbsolutePosition(if pos and (conf.app.allowOutside or hs.geometry(pos)\inside(frame)) then pos else frame.center)
      toggle = false
    lastName = nil
)\start!

app
