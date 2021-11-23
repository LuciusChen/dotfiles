_ = require 'lodash'
util = require 'util'

spotify_was_playing = false

-- Testing the new audiodevice watcher
hs.audiodevice.watcher.setCallback((arg)->
  
)
hs.audiodevice.watcher.start!

-- Per-device watcher to detect headphones in/out
_.forEach hs.audiodevice.allOutputDevices!, (v, k) ->
  v\watcherCallback((dev_uid, event_name, event_scope, event_element) ->
    dev = hs.audiodevice.findDeviceByUID(dev_uid)
    if event_name == 'jack'
      if v\jackConnected!
        if spotify_was_playing
          hs.spotify.play!
          util\notify("Headphones plugged", "Spotify restarted")
      else
         -- Cache current state to know whether we should resume
         -- when the headphones are connected again
        spotify_was_playing = hs.spotify.isPlaying!
        if spotify_was_playing
          hs.spotify.pause!
          util\notify("Headphones unplugged", "Spotify paused")
)\watcherStart!