hs.configdir = os.getenv("HOME") .. "/.hammerspoon"
package.path = table.concat({
    hs.configdir .. "/?.lua",
    hs.configdir .. "/?/init.lua",
    hs.configdir .. "/Spoons/?.spoon/init.lua",
    package.path,
}, ";")
hs.window.animationDuration = 0
hs.window.setFrameCorrectness = false

local tips = require("tips")
tips:init()
local conf = require("conf")
local util = require("util")
local layout = require("layout")

local fullMap = util:tableMerge(conf.powerMap, conf.appMap)

for _, value in pairs(conf.appMap) do
    table.insert(conf.blackList, value)
end

for k, v in pairs(fullMap) do
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

-- app not bind shortcuts
local createWindowChooser = function()
    local chooser = hs.chooser.new(function(choice)
        if choice then
            local window = hs.window.get(choice.id)
            window:focus()
            util:highlightActiveWindow()
        end
    end)

    conf.bind(conf.hyper, "space", function()
        local windows, wf = {}, hs.window.filter.new()
        local allWindows = wf:getWindows()

        for _, v in ipairs(allWindows) do
            local id = v:application():bundleID()
            if not util:includes(conf.blackList, id) then
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

inputMethodSwitcher = function(appName, eventType, appObject)
    if eventType == hs.application.watcher.activated then
        local appID = hs.application.frontmostApplication():bundleID()
        if util:includes(conf.inputMethod, appID) then
            hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
        else
            hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
        end
    end
end

appWatcher = hs.application.watcher.new(inputMethodSwitcher)
appWatcher:start()

-- wifi
setOutputMuted = function()
    local outputDeviceName = "MacBook Pro Speakers"
    local currentOutput = hs.audiodevice.current(false)
    local currentWifi = hs.wifi.currentNetwork()
    local mute = currentWifi == "ChangJH" or currentWifi == "ChangJH-jishu"
    if currentOutput.name == outputDeviceName then
        hs.audiodevice.findDeviceByName(outputDeviceName):setOutputMuted(mute)
    end
end

wifiWatcher = hs.wifi.watcher.new(setOutputMuted)
wifiWatcher:start()

-- TextClipboardHistory
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("TextClipboardHistory", {
    config = { show_in_menubar = false },
    hotkeys = { toggle_clipboard = { conf.hyper, "3" } },
    start = true,
})
spoon.SpoonInstall:andUse("Emojis")
spoon.SpoonInstall:andUse("HeadphoneAutoPause", { config = { control = { spotify = true }, start = true } })
spoon.Emojis:bindHotkeys({ toggle = { conf.hyper, "2" } })

-- Keyboard
local corne = 24679
executeCommand = function(eventType, profile)
    hs.alert.show("Keyboard " .. (eventType == "added" and "detected" or "removed") .. ".")
    local profileArg = eventType == "added" and profile or ""
    hs.execute(
        "'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile " .. profileArg
    )
end

usbWatcher = hs.usb.watcher.new(function(data)
    if data.productName == "IFKB 2.4G REC (STM)" then
        if data.eventType == "added" then
            executeCommand(data.eventType, "☯")
        else
            executeCommand(data.eventType, "")
        end
    end
end)
usbWatcher:start()

killCursorUIViewService = function()
    local processName = "CursorUIViewService"
    hs.execute("pkill -9 -f " .. processName)
    hs.alert.show("Killed " .. processName)
end

local timer = hs.timer.doEvery(86400, killCursorUIViewService)
killCursorUIViewService()

-- disable hide windows shortcuts
local noop = function() end
conf.bind({ "cmd", "alt" }, "h", noop)
conf.bind(conf.hyperPlus, "i", noop)
