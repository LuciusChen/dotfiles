mouse = require 'mouse'
util = require 'util'
conf = require 'conf'
layout = require 'layout'

app =
  toggleByBundleID: (id, max) ->
    () ->
      app = hs.application.frontmostApplication!
      if app and app\bundleID! == id
        app\hide!
      else
        hs.application.launchOrFocusByBundleID id
        mouse.frontmost!
        layout\max! if max
  running: (id, success, fail, activate) ->
    app = hs.application.get id
    if app
      if activate
        app\activate!
        util.delay conf.appActiveTimeout, ->
          success!
        util.delay conf.appHideTimeout, ->
          app\hide!
      else
        success!
    else
      fail!
app
