conf = require 'conf'
mouse = require 'mouse'
toggle = false

util =
  toggle: (id, maximize) =>
    toggle = true
    app = hs.application.frontmostApplication!
    if app\bundleID! == id
      app\hide!
    else
      hs.application.launchOrFocusByBundleID id
      layout\maximize! if maximize
      -- move cursor between monitors
      -- move mouse to the screen which the application is on
      mouse\frontmost!
      -- hs.mouse.setAbsolutePosition(hs.geometry.rectMidPoint(hs.window.focusedWindow!\screen!\fullFrame!))
  notify: (title, text) =>
    hs.notify.new({title:title, informativeText:text})\send!
  trim: (str) =>
    string.gsub(str, "^%s*(.-)%s*$", "%1")
  exec: (cmd) =>
    @trim hs.execute(cmd)
  getSysPwd: =>
    @exec('security find-generic-password -s hammerspoon -a system -w')
  checkSecurityAgent: =>
    @exec('osascript '..hs.configdir..'/lib/checkSecurityAgent.scpt')
  reload: =>
    @notify 'Configuration', 'Reload'
    hs.reload!
  merge: (t1, t2) ->
    for k,v in ipairs(t2) do
       table.insert(t1, v)
    t1
util
