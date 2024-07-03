local conf = require("conf")
local rectTable = {}

layout = {
    include = function(self, tbl, item)
        for _, value in pairs(tbl) do
            if value == item then
                return true
            end
        end
        return false
    end,
    win = function()
        return hs.window.frontmostWindow()
    end,
    frame = function(self, win)
        win = win or self:win()
        return win:frame():toUnitRect(win:screen():frame())
    end,
    leftHalf = function(self)
        return self:win():move(hs.layout.left50)
    end,
    rightHalf = function(self)
        return self:win():move(hs.layout.right50)
    end,
    upHalf = function(self)
        return self:win():move("[0,0,100,50]")
    end,
    downHalf = function(self)
        return self:win():move("[0,50,100,100]")
    end,
    leftUp = function(self)
        return self:win():move("[0,0,50,50]")
    end,
    leftDown = function(self)
        return self:win():move("[0,50,50,100]")
    end,
    rightUp = function(self)
        return self:win():move("[50,0,100,50]")
    end,
    rightDown = function(self)
        return self:win():move("[50,50,100,100]")
    end,
    larger = function(self)
        local frame = self:frame(self:win())
        local center = frame.center
        frame.w, frame.h = frame.w / 0.9, frame.h / 0.9
        frame.w, frame.h = math.min(frame.w, 1), math.min(frame.h, 1)
        frame.x, frame.y = center.x - frame.w / 2, center.y - frame.h / 2
        frame.x, frame.y = math.max(frame.x, 0), math.max(frame.y, 0)
        return self:win():move(frame)
    end,
    smaller = function(self)
        local frame = self:frame(self:win())
        local center = frame.center
        frame.w, frame.h = frame.w * 0.9, frame.h * 0.9
        frame.x, frame.y = center.x - frame.w / 2, center.y - frame.h / 2
        return self:win():move(frame)
    end,
    toggle = function(self)
        local win = self:win()
        local id = win:id()
        local frame = self:frame(win)
        if frame.x == 0 and frame.y == 0 and frame.h >= 0.99 and frame.w >= 0.99 then
            local rect = rectTable[id]
            return win:move(rect or "[25,25,75,75]")
        else
            rectTable[id] = frame
            return self:maximize(win)
        end
    end,
    maximize = function(self, win)
        win = win or self:win()
        return win:maximize()
    end,
    minimize = function(self)
        return self:win():minimize()
    end,
    center = function(self, win)
        win = win or self:win()
        return win:move("[29,10,74,90]")
    end,
    nextScreen = function(self)
        local win = self:win()
        local id = win:application():bundleID()
        local frame = self:frame(win)
        win:moveToScreen(win:screen():next(), true, true)
        if self:include(conf.frozen, id) then
            return win:move(frame)
        else
            return self:maximize(win)
        end
    end,
    preScreen = function(self)
        local win = self:win()
        local id = win:application():bundleID()
        local frame = self:frame(win)
        win:moveToScreen(win:screen():previous(), true, true)
        if self:include(conf.frozen, id) then
            return win:move(frame)
        else
            return self:maximize(win)
        end
    end,
    moveToScreen = function(self, i)
        local screen = hs.screen.allScreens()[tonumber(i)]
        print(i)
        if screen then
            return self:win():moveToScreen(screen, true, true):maximize()
        end
    end,
    screen = function(self)
        local win = self:win()
        return win:moveToScreen(win:screen():next(), true, true)
    end,
}
return layout
