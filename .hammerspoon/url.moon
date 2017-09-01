_ = require 'lodash'
util = require 'util'
layer = require 'layer'

hs.urlevent.bind('layerEnter', (name, data) ->
  layer[data.name]\enter!
)
hs.urlevent.bind('layerExit', (name, data) ->
  layer[data.name]\exit!
)
