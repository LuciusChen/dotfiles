hs.window.animationDuration = 0
hs.window.setFrameCorrectness = false

layout =
  frontmost: ->
    hs.window.frontmostWindow!
  leftHalf: =>
    @frontmost!\move hs.layout.left50
  rightHalf: =>
    @frontmost!\move hs.layout.right50
  max: =>
    @frontmost!\maximize!
  center: =>
    @frontmost!\move('[25,25,75,75]')
  upHalf: =>
    @frontmost!\move('[0,0,100,50]')
  downHalf: =>
    @frontmost!\move('[0,50,100,100]')
  screen: =>
    win = @frontmost!
    win\moveToScreen win\screen!\next!, true, true

layout
