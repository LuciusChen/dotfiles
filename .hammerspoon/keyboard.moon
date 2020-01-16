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

-- Handle cursor focus and application's screen manage.
hs.application.watcher.new((name, event, app) ->
  if event == hs.application.watcher.activated
        updateFrontmostAppInput!
)\start!