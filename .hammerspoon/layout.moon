-- The default duration for animations, in seconds. Initial value is 0.2; set to 0 to disable animations.
-- hs.window.animationDuration = 0 -- disable animations
hs.window.animationDuration = 0
-- The default value is false
hs.window.setFrameCorrectness = false

rectTable = {}

layout =
  -- hs.window.frontmostWindow() -> hs.window object
  win: ->
    hs.window.frontmostWindow!
  frame: (win) =>
    win or= @win!
    win\frame!\toUnitRect(win\screen!\frame!)
  leftHalf: =>
    @win!\move hs.layout.left50
  rightHalf: =>
    @win!\move hs.layout.right50
  upHalf: =>
    @win!\move('[0,0,100,50]')
  downHalf: =>
    @win!\move('[0,50,100,100]')
  leftUp: =>
    @win!\move('[0,0,50,50]')
  leftDown: =>
    @win!\move('[0,50,50,100]')
  rightUp: =>
    @win!\move('[50,0,100,50]')
  rightDown: =>
    @win!\move('[50,50,100,100]')
-- call frame:(win)
  larger: =>
    frame = @frame @win!
-- hs.geometry.center
    center = frame.center
    frame.w = frame.w / 0.9
    if frame.w > 1
      frame.w = 1
    frame.h = frame.h / 0.9
    if frame.h > 1
      frame.h = 1
    frame.x = center.x - frame.w/2
    if frame.x < 0
      frame.x = 0
    frame.y = center.y - frame.h/2
    if frame.y < 0
      frame.y = 0
    @win!\move frame
  smaller: =>
    frame = @frame @win!
    center = frame.center
    frame.w = frame.w * 0.9
    frame.h = frame.h * 0.9
    frame.x = center.x - frame.w/2
    frame.y = center.y - frame.h/2
    @win!\move frame
  toggle: =>
    win = @win!
    id = win\id!
    frame = @frame(win)
    if frame.x == 0 and frame.y == 0 and frame.h >= 0.99 and frame.w >= 0.99
      rect = rectTable[id]
      win\move(if rect then rect else '[25,25,75,75]')
    else
      rectTable[id] = frame
      @maximize win
  maximize: (win) =>
    win or= @win!
    win\maximize!
  minimize: =>
    @win!\minimize!
  center: (win) =>
    win or= @win!
    win\move('[25,25,75,75]')
  eastScreen: =>
    @win!\moveOneScreenEast!\maximize!
  westScreen: =>
    @win!\moveOneScreenWest!\maximize!
  southScreen: =>
    @win!\moveOneScreenSouth!\maximize!
  northScreen: =>
    @win!\moveOneScreenNorth!\maximize!
  nextScreen: =>
    win = @win!
    win\moveToScreen(win\screen!\next!, true, true)\maximize!
  preScreen: =>
    win = @win!
    win\moveToScreen(win\screen!\previous!, true, true)\maximize!
  moveToScreen: (i) =>
    screen = hs.screen.allScreens![tonumber i]
    if screen
      @win!\moveToScreen(screen, true, true)\maximize!
  screen: =>
    win = @win!
    win\moveToScreen win\screen!\next!, true, true
-- hs.mouse.getCurrentScreen() -> screen or nil
  mouse: =>
    @win!\moveToScreen(hs.mouse.getCurrentScreen!, true, true)\maximize!

layout
