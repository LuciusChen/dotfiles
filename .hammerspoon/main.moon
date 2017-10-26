conf = require 'conf'
_ = require 'lodash'

_.forEach conf.moudle, (v, k) ->
  require k if v
