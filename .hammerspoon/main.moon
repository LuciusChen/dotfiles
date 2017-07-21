conf = require 'conf'
export print = -> unless conf.debug

for k, v in pairs conf.moudle
  require k if v
