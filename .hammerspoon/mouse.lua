mouse = {
    moveToNextScreen = function(self)
        local fullFrame = hs.mouse.getCurrentScreen():next():fullFrame()
        return hs.mouse.absolutePosition(hs.geometry.rectMidPoint(fullFrame))
    end,
    frontmost = function()
        local winFrame = layout.win():frame()
        local mousePosition = hs.mouse.getRelativePosition()
        local fullFrame = hs.mouse.getCurrentScreen():fullFrame()
        local point = {
            x = winFrame.x + winFrame.w * mousePosition.x / fullFrame.w,
            y = winFrame.y + winFrame.h * mousePosition.y / fullFrame.h,
        }
        return hs.mouse.absolutePosition(point)
    end,
    mouseHighlight = function()
        if mouseCircle then
            mouseCircle:delete()
            mouseCircle = nil
            if mouseCircleTimer then
                mouseCircleTimer:stop()
            end
        end
        local mousepoint = hs.mouse.absolutePosition()
        mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x - 40, mousepoint.y - 40, 80, 80))
        mouseCircle:setStrokeColor({ red = 1, blue = 0, green = 0, alpha = 1 })
        mouseCircle:setFill(false)
        mouseCircle:setStrokeWidth(5)
        mouseCircle:show()
        mouseCircleTimer = hs.timer.doAfter(1, function()
            mouseCircle:delete()
            mouseCircle = nil
        end)
    end,
}
return mouse
