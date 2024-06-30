hs.configdir = os.getenv("HOME") .. "/.hammerspoon"
package.path = table.concat({
        hs.configdir .. "/?.lua",
        hs.configdir .. "/?/init.lua",
        hs.configdir .. "/Spoons/?.spoon/init.lua",
        package.path,
}, ";")
hs.window.animationDuration = 0
hs.window.setFrameCorrectness = false

local conf = require("conf")
local tips = require("tips")
tips:init()
local rectTable = {}
local frozen = {
        "ru.keepcoder.Telegram",
        "com.tencent.xinWeChat",
        "com.culturedcode.ThingsMac",
        "com.readdle.smartemail-Mac",
        "com.apple.finder",
        "org.gnu.Emacs",
}

local appItem = {
        "net.kovidgoyal.kitty",
        "com.jetbrains.intellij",
        "com.jetbrains.datagrip",
        "org.gnu.Emacs",
        "org.hammerspoon.Hammerspoon",
        "com.eusoft.eudic",
}

local blackList = {
        "org.hammerspoon.Hammerspoon",
        "com.apple.notificationcenterui",
}

local mouseCircle, mouseCircleTimer

local layout = {
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
        eastScreen = function(self)
                return self:win():moveOneScreenEast():maximize()
        end,
        westScreen = function(self)
                return self:win():moveOneScreenWest():maximize()
        end,
        southScreen = function(self)
                return self:win():moveOneScreenSouth():maximize()
        end,
        northScreen = function(self)
                return self:win():moveOneScreenNorth():maximize()
        end,
        nextScreen = function(self)
                local win = self:win()
                local id = win:application():bundleID()
                local frame = self:frame(win)
                win:moveToScreen(win:screen():next(), true, true)
                if util:includes(frozen, id) then
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
                if util:includes(frozen, id) then
                        return win:move(frame)
                else
                        return self:maximize(win)
                end
        end,
        moveToScreen = function(self, i)
                local screen = hs.screen.allScreens()[tonumber(i)]
                if screen then
                        return self:win():moveToScreen(screen, true, true):maximize()
                end
        end,
        screen = function(self)
                local win = self:win()
                return win:moveToScreen(win:screen():next(), true, true)
        end,
        mouse = function(self)
                return self:win():moveToScreen(hs.mouse.getCurrentScreen(), true, true):maximize()
        end,
}

local mouse = {
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

local util = {
        includes = function(self, tbl, item)
                for _, value in pairs(tbl) do
                        if value == item then
                                return true
                        end
                end
                return false
        end,
        toggle = function(self, id, maximize)
                local app = hs.application.frontmostApplication()
                if app:bundleID() == id then
                        return app:hide()
                else
                        hs.application.launchOrFocusByBundleID(id)
                        if maximize then
                                layout:maximize()
                        end
                        return mouse:frontmost()
                end
        end,
        notify = function(self, title, text)
                return hs.notify.new({ title = title, informativeText = text }):send()
        end,
        trim = function(self, str)
                return string.gsub(str, "^%s*(.-)%s*$", "%1")
        end,
        reload = function(self)
                self:notify("Configuration", "Reload")
                return hs.reload()
        end,
        merge = function(t1, t2)
                for k, v in ipairs(t2) do
                        table.insert(t1, v)
                end
                return t1
        end,
        tableMerge = function(self, a, b)
                if type(a) == "table" and type(b) == "table" then
                        for k, v in pairs(b) do
                                if type(v) == "table" and type(a[k] or false) == "table" then
                                        self:tableMerge(a[k], v)
                                else
                                        a[k] = v
                                end
                        end
                end
                return a
        end,
        split = function(s, delimiter)
                local result = {}
                for match in (s .. delimiter):gmatch("([^.]*)" .. delimiter) do
                        table.insert(result, match)
                end
                return result
        end,
}

local powerMap = {
        ["7"] = function()
                mouse:mouseHighlight()
        end,
        ["8"] = hs.spotify.previous,
        ["9"] = hs.spotify.playpause,
        ["0"] = hs.spotify.next,
        ["-"] = hs.spotify.volumeDown,
        ["="] = hs.spotify.volumeUp,
        ["\\"] = function()
                util:reload()
        end,
        [","] = "com.apple.systempreferences",
        ["."] = hs.toggleConsole,
        ["return"] = hs.caffeinate.lockScreen,
        ["/"] = function()
                tips:toggle()
        end,
}

local appMap = util:tableMerge(conf.appMap, powerMap)

for _, value in pairs(appMap) do
        table.insert(blackList, value)
end

for k, v in pairs(conf.appMap) do
        if type(v) == "function" then
                conf.bind(conf.hyper, k, v)
        elseif #v > 0 then
                conf.bind(conf.hyper, k, function()
                        util:toggle(v)
                end)
        end
end

for k, v in pairs(conf.layoutMap) do
        conf.bind(conf.hyperPlus, k, function()
                k = tonumber(k)
                return layout[v](
                        layout,
                        (function()
                                if type(k) == "number" then
                                        return k
                                end
                        end)()
                )
        end)
end

local createWindowChooser = function()
        local chooser = hs.chooser.new(function(choice)
                if choice then
                        local window = hs.window.get(choice.id)
                        window:focus()
                end
        end)

        conf.bind(conf.hyper, "space", function()
                local windows, wf = {}, hs.window.filter.new()
                local allWindows = wf:getWindows()

                for _, v in ipairs(allWindows) do
                        local id = v:application():bundleID()
                        if not util:includes(blackList, id) then
                                table.insert(windows, {
                                        text = v:application():name(),
                                        subText = v:title(),
                                        bundleID = v:application():bundleID(),
                                        id = v:id(),
                                })
                        end
                end

                if #windows > 0 then
                        chooser:choices(windows)
                        chooser:show()
                end
        end)
end

createWindowChooser()

local updateFrontmostAppInput = function()
        local appID = hs.application.frontmostApplication():bundleID()
        if util:includes(appItem, appID) then
                hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
        else
                hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
        end
end

local applicationWatcher = function(appName, eventType, appObject)
        if eventType == hs.application.watcher.activated then
                updateFrontmostAppInput()
                if appName == "Finder" then
                        appObject:selectMenuItem({ "Window", "Bring All to Front" })
                end
        end
end

local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

local setOutputMuted = function()
        local outputDeviceName = "MacBook Pro Speakers"
        local currentOutput = hs.audiodevice.current(false)
        local currentWifi = hs.wifi.currentNetwork()
        local mute = currentWifi == "ChangJH" or currentWifi == "ChangJH-jishu"
        if currentOutput.name == outputDeviceName then
                hs.audiodevice.findDeviceByName(outputDeviceName):setOutputMuted(mute)
        end
end

local wifiWatcher = hs.wifi.watcher.new(setOutputMuted)
wifiWatcher:start()

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("TextClipboardHistory", {
        config = { show_in_menubar = false },
        hotkeys = { toggle_clipboard = { conf.hyper, "3" } },
        start = true,
})
spoon.SpoonInstall:andUse("Emojis")
spoon.SpoonInstall:andUse("HeadphoneAutoPause", { config = { control = { spotify = true }, start = true } })
spoon.Emojis:bindHotkeys({ toggle = { conf.hyper, "2" } })

local noop = function() end
conf.bind({ "cmd", "alt" }, "h", noop)
conf.bind(conf.hyperPlus, "i", noop)

local executeCommand = function(eventType, profile)
        hs.alert.show("Keyboard " .. (eventType == "added" and "detected" or "removed") .. ".")
        local profileArg = eventType == "added" and profile or ""
        hs.execute(
                "'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile " .. profileArg
        )
end

local usbWatcher = hs.usb.watcher.new(function(data)
        if data.productName == "HHKB Professional" then
                executeCommand(data.eventType, "⌨️")
        elseif data.productName == "IFKB 2.4G REC (STM)" then
                executeCommand(data.eventType, "🪽")
        end
end)
usbWatcher:start()
