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
    table.insert(conf.blackList, value)
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

-- app not bind shortcuts
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

-- inputMethod
local appWatcher = nil

local function safeCallback(appName, eventType, appObject)
    local status, err = pcall(function()
        if eventType == hs.application.watcher.activated then
            local appID = hs.application.frontmostApplication():bundleID()
            -- logger.d("App activated: " .. appID)

            if util:includes(conf.inputMethod, appID) then
                -- logger.d("Switching to ABC")
                hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
            else
                -- logger.d("Switching to Squirrel")
                hs.keycodes.currentSourceID("im.rime.inputmethod.Squirrel.Hans")
            end
        end
    end)
end

local function startAppWatcher()
    if appWatcher then
        appWatcher:stop()
    end
    appWatcher = hs.application.watcher.new(safeCallback)
    appWatcher:start()
end

-- 初始启动
startAppWatcher()

-- 每小时重启一次
hs.timer.doEvery(3600, startAppWatcher)

-- wifi
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

-- disable hide windows shortcuts
local noop = function() end
conf.bind({ "cmd", "alt" }, "h", noop)
conf.bind(conf.hyperPlus, "i", noop)

-- Keyboard
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
