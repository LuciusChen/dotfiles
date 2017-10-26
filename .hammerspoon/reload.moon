_ = require 'lodash'
util = require 'util'

hs.pathwatcher.new(hs.configdir, (files) ->
  _.some files, (v) ->
    if v\sub(-5) == '.moon'
      util\reload!
      return true
)\start!
