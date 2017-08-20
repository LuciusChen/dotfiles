_ = require 'moses'
app = require 'app'
util = require 'util'
conf = require 'conf'
codes = hs.keycodes.map
codes.leftShift = 56
codes.leftCtrl = 59
codes.leftAlt = 58
codes.leftCmd = 55
codes.rightCmd = 54
codes.rightAlt = 61

{
  :new
  keyStroke: press
  event:
    types:
      :keyDown
      :keyUp
      :flagsChanged
    newKeyEvent: keyEvent
    newSystemKeyEvent: sysEvent
} = hs.eventtap

sys = (name, mods={}) ->
  sysEvent(name, true)\setFlags(mods)\post!
  util.delay conf.sysEventTimeout, ->
    sysEvent(name, false)\setFlags(mods)\post!

key = (mods, key, isdown) ->
  key = if _.isNumber key then key else codes[key]
  keyEvent(mods, 'a', isdown)\setKeyCode key

state = {}

export eventtapWatcher = new({ keyDown, keyUp, flagsChanged }, (e) ->
  type, code, flags = e\getType!, e\getKeyCode!, e\getFlags!
  mods = _.keys flags
  print hs.eventtap.event.types[type], codes[code], code, _.concat(mods, ',')


  -- tab -> tab/Layer 1
  if code == codes.tab and type == keyDown
    state.oneDown = true
    return true
  elseif code == codes.tab and type == keyUp
    state.oneDown = false
    if state.oneCombo
      state.oneCombo = false
      return true
    else
      return true, {
        key mods, code, true
        key mods, code, false
      }
  elseif state.oneDown and type == keyDown
    state.oneCombo = true
    layer1 =
      sys:
        q: 'BRIGHTNESS_DOWN'
        w: 'BRIGHTNESS_UP'
        t: 'ILLUMINATION_DOWN'
        y: 'ILLUMINATION_UP'
        u: 'REWIND'
        i: 'PLAY'
        o: 'FAST'
        p: 'MUTE'
        ['[']: 'SOUND_DOWN'
        [']']: 'SOUND_UP'
      key:
        ['1']: 'f1'
        ['2']: 'f2'
        ['3']: 'f3'
        ['4']: 'f4'
        ['5']: 'f5'
        ['6']: 'f6'
        ['7']: 'f7'
        ['8']: 'f8'
        ['9']: 'f9'
        ['0']: 'f10'
        ['-']: 'f11'
        ['=']: 'f12'
        delete: 'forwarddelete'
        h: 'left'
        j: 'down'
        k: 'up'
        l: 'right'
        n: 'home'
        m: 'pagedown'
        [',']: 'pageup'
        ['.']: 'end'
      mod:
        z: { {'cmd', 'shift'}, '3' }
        x: { {'cmd', 'shift', 'ctrl'}, '3' }
        c: { {'cmd', 'shift'}, '4' }
        v: { {'cmd', 'shift', 'ctrl'}, '4' }
    layerKey = layer1.key[codes[code]]
    layerSys = layer1.sys[codes[code]]
    layerMod = layer1.mod[codes[code]]
    if layerKey
      return true, {
        key mods, layerKey, true
        key mods, layerKey, false
      }
    elseif layerSys
      sys layerSys
      return true
    elseif layerMod
      { modMods, modKey } = layerMod
      return true, {
        key modMods, modKey, true
        key modMods, modKey, false
      }
    else
      return false
  elseif state.oneDown and type == keyUp
    return true
  state.leftCmdDown = false
  state.leftAltDown = false
  state.leftCtrlDown = false
  state.leftShiftDown = false

  return false
)\start!
