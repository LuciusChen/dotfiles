conf = require 'conf'
util = require 'util'
_ = require 'moses'
{
  keyStroke: press
  keyStrokes: send
  event:
    newKeyEvent: keyEvent
} = hs.eventtap

state = {}

hs.application.watcher.new((name, event, app)->{
  -- print name, event
  if name=='SecurityAgent'
    if event == 5
      send util.getSystemPwd!
      state.inSecurityAgent = true
    else
      state.inSecurityAgent = nil
  if _.include(conf.securityAgentWhiteList, name) and event == 6 and state.inSecurityAgent
    press {}, 'return'
})\start!
