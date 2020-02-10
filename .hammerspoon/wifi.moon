_ = require 'lodash'
util = require 'util'

currentWifi = hs.wifi.currentNetwork!
work = {
   'ChangJH',
   'ChangJH-jishu'
}

setOutputMuted = ->
  outputDeviceName = 'Built-in Output'
  currentOutput = hs.audiodevice.current(false)
  if not currentWifi
    return
  if _.includes(work, currentWifi) and currentOutput.name == outputDeviceName
    hs.audiodevice.findDeviceByName(outputDeviceName)\setOutputMuted(true)

hs.wifi.watcher.new(() ->
        setOutputMuted!
        wifiNotify!
)\start!