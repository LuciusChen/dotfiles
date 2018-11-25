rectanglePreviewColor = '#8FA5A3'
rectanglePreview = hs.drawing.rectangle(
  hs.geometry.rect(0, 0, 0, 0)
)

rectanglePreview = hs.drawing.rectangle(hs.geometry.rect(0, 0, 0, 0))
rectanglePreview\setStrokeWidth(2)
rectanglePreview\setStrokeColor({ hex:rectanglePreviewColor, alpha:1 })
rectanglePreview\setFillGradient(color, endColor, 45)
rectanglePreview\setRoundedRectRadii(2, 2)
rectanglePreview\setStroke(true)\setFill(true)
rectanglePreview\setLevel("floating")

openIterm = () ->
  frame = rectanglePreview\frame()
  createItermWithBounds = string.format([[
    if application "iTerm" is not running then
      launch application "iTerm"
    end if
    tell application "iTerm"
      set newWindow to (create window with default profile)
      set the bounds of newWindow to {%i, %i, %i, %i}
    end tell
  ]], frame.x, frame.y, frame.x + frame.w, frame.y + frame.h)
  hs.osascript.applescript(createItermWithBounds)

fromPoint = nil

drag_event = hs.eventtap.new(
  { hs.eventtap.event.types.mouseMoved },
  (e) ->
    toPoint = hs.mouse.getAbsolutePosition()
    newFrame = hs.geometry.new({
      x1: fromPoint.x,
      y1: fromPoint.y,
      x2: toPoint.x,
      y2: toPoint.y,
    })
    rectanglePreview\setFrame(newFrame)
    nil
  )

flags_event = hs.eventtap.new(
  { hs.eventtap.event.types.flagsChanged },
  (e) ->
    flags = e\getFlags()
    if flags.ctrl and flags.shift then
      fromPoint = hs.mouse.getAbsolutePosition()
      startFrame = hs.geometry.rect(fromPoint.x, fromPoint.y, 0, 0)
      rectanglePreview\setFrame(startFrame)
      drag_event\start()
      rectanglePreview\show()
    elseif fromPoint != nil then
      fromPoint = nil
      drag_event\stop()
      rectanglePreview\hide()
      openIterm()
    nil
)
flags_event\start()
