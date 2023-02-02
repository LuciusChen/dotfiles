_ = require 'lodash'

-- execute hs.keycodes.currentSourceID() in Hammerspoon's console to query SourceID
squirrel= ->
  hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hant")
--  hs.keycodes.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
abc= ->
  hs.keycodes.currentSourceID("com.apple.keylayout.ABC")

-- app need to switch keyboard to ABC
appItem = {
   'com.googlecode.iterm2',
   'com.jetbrains.intellij',
   'com.jetbrains.datagrip',
   'com.microsoft.VSCode',
   'org.gnu.Emacs',
   'com.postmanlabs.mac',
   'org.hammerspoon.Hammerspoon',
   'com.eusoft.eudic'
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