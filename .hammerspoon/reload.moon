_ = require 'moses'
util = require 'util'

export confWatcher = hs.pathwatcher.new(hs.configdir, (files) ->
  _.each files, (k, v) ->
    if v\sub(-5) == '.moon'
      util\reload!
)\start!
