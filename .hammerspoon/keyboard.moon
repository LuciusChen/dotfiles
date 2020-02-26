_ = require 'lodash'

-- execute hs.keycodes.currentSourceID() in Hammerspoon's console to query SourceID
squirrel= ->
  hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Rime")
abc= ->
  hs.keycodes.currentSourceID("com.apple.keylayout.ABC")

-- app need to switch keyboard to ABC
appItem = {
   'com.googlecode.iterm2',
   'com.jetbrains.intellij',
   'com.jetbrains.datagrip',
   'com.microsoft.VSCode',
   'com.postmanlabs.mac'
}

updateFrontmostAppInput= ->
  appID = hs.application.frontmostApplication!\bundleID!
  if _.includes(appItem, appID)
    abc!
  else
    squirrel!

hs.application.watcher.new((name, event, app) ->
  if event == hs.application.watcher.activated
    updateFrontmostAppInput!
)\start!


hs.usb.watcher.new((data) -> 
  -- print(data["productID"] )
  if (data["productName"] == "HHKB Professional") then
    if (data["eventType"] == "added") then
      hs.alert.show("Keyboard detected.")
      hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile HHKB")
    elseif (data["eventType"] == "removed") then
      hs.alert.show("Keyboard removed.")
      hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile Apple")
)\start!