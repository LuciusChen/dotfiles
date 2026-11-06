local conf = require("conf")
local util = require("util")
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
    centerHalf = function(self)
        return self:win():move("[25,25,75,75]")
    end,
    maximize = function(self, win)
        win = win or self:win()
        return win:maximize()
    end,
    nextScreen = function(self)
        local win = self:win()
        local id = win:application():bundleID()
        local frame = self:frame(win)
        win:moveToScreen(win:screen():next(), true, true)
        print("conf.frozen:", hs.inspect(conf.frozen))
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
