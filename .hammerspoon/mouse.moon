layout = require 'layout'
conf = require 'conf'

mouseCircle = nil
mouseCircleTimer = nil

mouse =
  clickNotificationUp: =>
    @clickNotification({
      x: hs.screen.primaryScreen!\fullFrame!.w-conf.notification.up.x
      y: conf.notification.up.y
    })
  clickNotificationDown: =>
    @clickNotification({
      x: hs.screen.primaryScreen!\fullFrame!.w-conf.notification.down.x
      y: conf.notification.down.y
    })
  clickNotification: (point) =>
    mouse = hs.eventtap.event.newMouseEvent
    types = hs.eventtap.event.types
    clickState = hs.eventtap.event.properties.mouseEventClickState
    mouse(types.leftMouseDown, point)\setProperty(clickState, 1)\post!
    mouse(types.leftMouseUp, point)\setProperty(clickState, 1)\post!
  moveToNextScreen: =>
    fullFrame = hs.mouse.getCurrentScreen!\next!\fullFrame!
    hs.mouse.absolutePosition(hs.geometry.rectMidPoint(fullFrame))
  frontmost: ->
    winFrame = layout.win!\frame!
    mousePosition = hs.mouse.getRelativePosition!
    fullFrame = hs.mouse.getCurrentScreen!\fullFrame!
    point =
      x: winFrame.x+winFrame.w*mousePosition.x/fullFrame.w
      y: winFrame.y+winFrame.h*mousePosition.y/fullFrame.h
    hs.mouse.absolutePosition point
  mouseHighlight: ->
    if mouseCircle
        mouseCircle\delete!
        mouseCircle=nil
        if mouseCircleTimer
            mouseCircleTimer\stop!
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition!
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle\setStrokeColor({["red"]:1,["blue"]:0,["green"]:0,["alpha"]:1})
    mouseCircle\setFill(false)
    mouseCircle\setStrokeWidth(5)
    mouseCircle\show!
    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(1, ()->
      mouseCircle\delete!
      mouseCircle=nil
      )
mouse
