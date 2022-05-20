window = require "hs.window"
spaces = require 'hs.spaces'
bind = hs.hotkey.bind

getGoodFocusedWindow= (nofull) ->
  win = window.focusedWindow()
  if not win or not win\isStandard!
    return
  if nofull and win\isFullScreen!
    return
  return win

flashScreen= (screen) ->
  flash = hs.canvas.new(screen\fullFrame!)\appendElements({
	  action: "fill",
	  fillColor: {
           alpha: 0.25, 
           red: 1
         },
	 type: "rectangle"
  })
  flash\show!
  hs.timer.doAfter .15, ()-> flash\delete!

switchSpace= (skip, dir) ->
  for i=1, skip do
    hs.eventtap.keyStroke({'ctrl', 'fn'}, dir, 0) -- "fn" is a bugfix!


moveWindowOneSpace= (dir, switchOrNot) ->
  win = getGoodFocusedWindow(true)
  if not win
    return
  screen = win\screen!
  uuid = screen\getUUID!
  userSpaces = nil
  for k,v in pairs(spaces.allSpaces()) do
    userSpaces = v
    if k == uuid then break
  if not userSpaces then return
  thisSpace=spaces.windowSpaces(win) -- first space win appears on
  if not thisSpace
    return 
  else 
    thisSpace=thisSpace[1]
  last = nil
  skipSpaces = 0
  for k, v in ipairs(userSpaces) do
    if spaces.spaceType(v) ~= "user" -- skippable space
      skipSpaces = skipSpaces + 1
    else
      if last and ((dir == 'left'  and v == thisSpace) or (dir == 'right' and last == thisSpace))
        newSpace = (dir=="left" and last or v)
        if switchOrNot
           switchSpace(skipSpaces+1, dir)
        print(newSpace)
        spaces.moveWindowToSpace(win, newSpace)
        return
      last = v
      skipSpaces = 0
  flashScreen(screen)   -- Shouldn't get here, so no space found

hs.hotkey.bind('⌘⌃⌥', "q",nil, () -> moveWindowOneSpace("right",true))
hs.hotkey.bind('⌘⌃⌥', "a",nil, () -> moveWindowOneSpace("left",true))
hs.hotkey.bind('⌘⌃⌥⇧', "q",nil, () -> moveWindowOneSpace("right",false))
hs.hotkey.bind('⌘⌃⌥⇧', "a",nil, ()-> moveWindowOneSpace("left",false))