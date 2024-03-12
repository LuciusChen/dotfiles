-- Needed until  https://github.com/Hammerspoon/hammerspoon/issues/2478 is fixed
hs.configdir = os.getenv('HOME') .. '/.hammerspoon'
package.path = hs.configdir .. '/?.lua;' .. hs.configdir .. '/?/init.lua;' .. hs.configdir .. '/Spoons/?.spoon/init.lua;' .. package.path
hs.window.animationDuration = 0
hs.window.setFrameCorrectness = false

conf = {
    debug = true,
    securityAgentWhiteList = {
        'System Preferences'
    },
    hyper = '⌘⌃⌥',
    hyperPlus = '⌘⌃⌥⇧',
    bind = hs.hotkey.bind,
    appMap = {
        w = 'ru.keepcoder.Telegram',
        s = 'com.tencent.xinWeChat',
        x = 'md.obsidian',
        e = 'com.jetbrains.intellij',
        d = 'com.jetbrains.datagrip',
        c = 'net.kovidgoyal.kitty',
        r = 'org.gnu.Emacs',
        f = 'com.apple.finder',
        v = 'com.microsoft.VSCode',
        t = 'com.calibre-ebook.ebook-viewer',
        g = 'company.thebrowser.Browser',
        b = 'com.readdle.PDFExpert-Mac',
        y = 'com.spotify.client',
        h = 'com.tencent.WeWorkMac',
        n = 'net.ankiweb.dtop',
        u = 'com.readdle.smartemail-Mac',
        j = 'com.seriflabs.affinitydesigner',
        m = 'com.postmanlabs.mac',
        i = 'org.zotero.zotero',
        k = 'com.nssurge.surge-mac',
        o = 'com.captureone.captureone15',
        l = 'com.figma.Desktop',
        p = 'com.adobe.Photoshop'
    },
    layoutMap = {
        h = 'center',
        i = 'minimize',
        ['space'] = 'toggle',
        k = 'maximize',
        y = 'upHalf',
        n = 'downHalf',
        g = 'leftHalf',
        j = 'rightHalf',
        t = 'leftUp',
        u = 'rightUp',
        b = 'leftDown',
        m = 'rightDown',
        ['['] = 'preScreen',
        [']'] = 'nextScreen',
        ['='] = 'larger',
        ['-'] = 'smaller'
    }
}

rectTable = { }
frozen = {
    'ru.keepcoder.Telegram',
    'com.tencent.xinWeChat',
    'com.culturedcode.ThingsMac',
    'com.readdle.smartemail-Mac',
    'com.apple.finder',
    'org.gnu.Emacs'
}

appItem = {
    'net.kovidgoyal.kitty',
    'com.jetbrains.intellij',
    'com.jetbrains.datagrip',
    'org.gnu.Emacs',
    'org.hammerspoon.Hammerspoon',
    'com.eusoft.eudic'
}

notification = {
    up = {
        x = 80,
        y = 60
    },
    down = {
        x = 80,
        y = 80
    }
}

mouseCircle = nil
mouseCircleTimer = nil

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
            y = winFrame.y + winFrame.h * mousePosition.y / fullFrame.h
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
        mouseCircle:setStrokeColor({
            ["red"] = 1,
            ["blue"] = 0,
            ["green"] = 0,
            ["alpha"] = 1
        })
        mouseCircle:setFill(false)
        mouseCircle:setStrokeWidth(5)
        mouseCircle:show()
        mouseCircleTimer = hs.timer.doAfter(1, function()
                                                   mouseCircle:delete()
                                                   mouseCircle = nil
                                               end)
    end
}

layout = {
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
        return self:win():move('[0,0,100,50]')
    end,
    downHalf = function(self)
        return self:win():move('[0,50,100,100]')
    end,
    leftUp = function(self)
        return self:win():move('[0,0,50,50]')
    end,
    leftDown = function(self)
        return self:win():move('[0,50,50,100]')
    end,
    rightUp = function(self)
        return self:win():move('[50,0,100,50]')
    end,
    rightDown = function(self)
        return self:win():move('[50,50,100,100]')
    end,
    larger = function(self)
        local frame = self:frame(self:win())
        local center = frame.center
        frame.w = frame.w / 0.9
        if frame.w > 1 then
            frame.w = 1
        end
        frame.h = frame.h / 0.9
        if frame.h > 1 then
            frame.h = 1
        end
        frame.x = center.x - frame.w / 2
        if frame.x < 0 then
            frame.x = 0
        end
        frame.y = center.y - frame.h / 2
        if frame.y < 0 then
            frame.y = 0
        end
        return self:win():move(frame)
    end,
    smaller = function(self)
        local frame = self:frame(self:win())
        local center = frame.center
        frame.w = frame.w * 0.9
        frame.h = frame.h * 0.9
        frame.x = center.x - frame.w / 2
        frame.y = center.y - frame.h / 2
        return self:win():move(frame)
    end,
    toggle = function(self)
        local win = self:win()
        local id = win:id()
        local frame = self:frame(win)
        if frame.x == 0 and frame.y == 0 and frame.h >= 0.99 and frame.w >= 0.99 then
            local rect = rectTable[id]
            return win:move((function()
                if rect then
                    return rect
                else
                    return '[25,25,75,75]'
                end
                             end)())
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
        return win:move('[29,10,74,90]')
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
    end
}

util = {
    includes = function(self, tbl, item)
        for _, value in pairs(tbl) do
            if value == item then
                return true
            end
        end
        return false
    end,
    toggle = function(self, id, maximize)
        toggle = true
        local app = hs.application.frontmostApplication()
        if app:bundleID() == id then
            return app:hide()
        else
            hs.logger.new('myapp', 'debug'):i('的 Bundle ID 是 ' .. id)
            hs.application.launchOrFocusByBundleID(id)
            if maximize then
                layout:maximize()
            end
            return mouse:frontmost()
        end
    end,
    notify = function(self, title, text)
        return hs.notify.new({
            title = title,
            informativeText = text
        }):send()
    end,
    trim = function(self, str)
        return string.gsub(str, "^%s*(.-)%s*$", "%1")
    end,
    reload = function(self)
        self:notify('Configuration', 'Reload')
        return hs.reload()
    end,
    merge = function(t1, t2)
        for k, v in ipairs(t2) do
            table.insert(t1, v)
        end
        return t1
    end,
    tableMerge = function(self, a, b)
        if type(a) == 'table' and type(b) == 'table' then
            for k, v in pairs(b) do
                if type(v) == 'table' and type(a[k] or false) == 'table' then
                    self:tableMerge(a[k], v)
                else
                    a[k] = v
                end
            end
        end
        return a
    end,
    split = function(s, delimiter)
        local result = { }
        for match in (s .. delimiter):gmatch("([^.]*)" .. delimiter) do
            table.insert(result, match)
        end
        return result
    end
}

local powerMap = {
    ['7'] = function() mouse:mouseHighlight() end,
    ['8'] = hs.spotify.previous,
    ['9'] = hs.spotify.playpause,
    ['0'] = hs.spotify.next,
    ['-'] = hs.spotify.volumeDown,
    ['='] = hs.spotify.volumeUp,
    ['\\'] = function() util:reload() end,
    [','] = 'com.apple.systempreferences',
    ['.'] = hs.toggleConsole,
    ['return'] = hs.caffeinate.lockScreen
}

appMap = util:tableMerge(conf.appMap, powerMap)

for k, v in pairs(conf.appMap) do
    if type(v) == 'function' then
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
                                     return layout[v](layout, (function()
                                         if type(k) == 'number' then
                                             return k
                                         end
                                                               end)())
                                 end)
end


function updateFrontmostAppInput()
    local appID = hs.application.frontmostApplication():bundleID()
    if util:includes(appItem, appID) then
        return hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
    else
        return hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
    end
end

function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        updateFrontmostAppInput()
        if (appName == "Finder") then
            updateFrontmostAppInput()
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({"Window", "Bring All to Front"})
        end
    end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

-- Add print(hs.location.get()) at the top of your init.lua and reload the config.
-- This will add Hammerspoon to System Settings -> Location Services. Enable location services for HS and restart HS.
-- After this hs.wifi.currentNetwork() should provide the proper SSID.
function setOutputMuted()
    local outputDeviceName = 'MacBook Pro Speakers'
    local currentOutput = hs.audiodevice.current(false)
    local currentWifi = hs.wifi.currentNetwork()
    if (currentWifi == 'ChangJH' or currentWifi =='ChangJH-jishu') and currentOutput.name == outputDeviceName then
        return hs.audiodevice.findDeviceByName(outputDeviceName):setOutputMuted(true)
    else
        return hs.audiodevice.findDeviceByName(outputDeviceName):setOutputMuted(false)
    end
end

wifiWatcher = hs.wifi.watcher.new(setOutputMuted)
wifiWatcher:start()

-- "clipboard History" and "Emojis" dependent on "SpoonInstall"
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall:andUse('TextClipboardHistory', {config = {show_in_menubar = false}, hotkeys = {toggle_clipboard = {conf.hyper, "3" }}, start= true})
spoon.SpoonInstall:andUse('Emojis')
spoon.SpoonInstall:andUse("HeadphoneAutoPause",{config = {control = {spotify = true},start = true}})
spoon.Emojis:bindHotkeys({toggle = {conf.hyper, "2" }})

-- ignore system shortcuts
function noop() end
-- conf.bind({ 'cmd' }, 'h', noop)
conf.bind({ 'cmd', 'alt' }, 'h', noop)
conf.bind(conf.hyperPlus, 'i', noop)


executeCommand = function(eventType, profile)
  if (eventType == "added") then
    hs.alert.show("Keyboard detected.")
    return hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile " .. profile)
  elseif (eventType == "removed") then
    hs.alert.show("Keyboard removed.")
    return hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile ")
  end
end
return hs.usb.watcher.new(function(data)
  if (data["productName"] == "HHKB Professional") then
    return executeCommand(data["eventType"], "⌨️")
  elseif (data["productName"] == "IFKB 2.4G REC (STM)") then
    return executeCommand(data["eventType"], "🪽")
  end
end):start()
