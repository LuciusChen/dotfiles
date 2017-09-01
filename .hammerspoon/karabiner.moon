conf = require 'conf'
_ = require 'lodash'
util = require 'util'

yamlChanged = false
jsonChanged = false
hs.pathwatcher.new(conf.karabiner.json, ->
  -- https://github.com/morikuni/y2j2y
  -- https://github.com/tekezo/Karabiner-Elements/blob/master/src/scripts/copy_current_profile_to_system_default_profile.applescript
  output, status = hs.execute("echo "..util\getSysPwd!.."|sudo -S "..conf.karabiner.copy)
  if status
    util.notify 'Karabiner', '同步配置'
  else
    util.notify 'Karabiner', '同步配置失败'
  if yamlChanged
    yamlChanged = false
  else
    jsonChanged = true
    hs.execute('cat '..conf.karabiner.json..'|'..hs.configdir..'/lib/json2yaml > '..conf.karabiner.yaml)
)\start!

hs.pathwatcher.new(conf.karabiner.yaml, ->
  if jsonChanged
    jsonChanged = false
  else
    yamlChanged = true
    hs.execute('cat '..conf.karabiner.yaml..'|'..hs.configdir..'/lib/yaml2json > '..conf.karabiner.json)
)\start!
