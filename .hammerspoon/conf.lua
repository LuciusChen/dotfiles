conf = {
    debug = true,
    securityAgentWhiteList = { "System Preferences" },
    hyper = "⌘⌃⌥",
    hyperPlus = "⌘⌃⌥⇧",
    bind = hs.hotkey.bind,
    appMap = {
        w = "ru.keepcoder.Telegram",
        s = "com.tencent.xinWeChat",
        x = "com.tencent.qq",
        e = "com.jetbrains.intellij",
        d = "com.jetbrains.datagrip",
        c = "com.github.wez.wezterm",
        r = "org.gnu.Emacs",
        f = "com.apple.finder",
        v = "com.microsoft.VSCode",
        t = "com.calibre-ebook.ebook-viewer",
        g = "company.thebrowser.Browser",
        b = "com.readdle.PDFExpert-Mac",
        y = "com.spotify.client",
        h = "com.tencent.WeWorkMac",
        n = "net.ankiweb.dtop",
        u = "com.readdle.smartemail-Mac",
        j = "org.inkscape.Inkscape",
        m = "io.mpv",
        i = "com.tencent.weread",
        k = "com.nssurge.surge-mac",
        o = "com.apple.ScreenContinuity",
        l = "com.figma.Desktop",
        p = "com.adobe.Photoshop",
    },
    frozen = {
        "ru.keepcoder.Telegram",
        "com.tencent.xinWeChat",
        "com.culturedcode.ThingsMac",
        "com.readdle.smartemail-Mac",
        "com.apple.finder",
        "org.gnu.Emacs",
    },
    layoutMap = {
        h = "center",
        i = "minimize",
        ["space"] = "toggle",
        k = "maximize",
        y = "upHalf",
        n = "downHalf",
        g = "leftHalf",
        j = "rightHalf",
        t = "leftUp",
        u = "rightUp",
        b = "leftDown",
        m = "rightDown",
        ["["] = "preScreen",
        ["]"] = "nextScreen",
        ["="] = "larger",
        ["-"] = "smaller",
        ["left"] = "jumpWindowLeft",
        ["down"] = "jumpWindowBelow",
        ["up"] = "jumpWindowAbove",
        ["right"] = "jumpWindowRight",
    },
    powerMap = {
        ["7"] = function()
            util:highlightActiveWindow()
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
        [";"] = function()
            util:emptyTrash()
        end,
        ["up"] = function()
            util:toogleDock()
        end,
        ["F6"] = function()
            util:executeCommand("emacsclient -e '(popup-frame-chatgpt-translate)'")
        end,
        ["F7"] = function()
            util:executeCommand("emacsclient -e '(popup-frame-password-store-copy)'")
        end,
        ["F8"] = function()
            util:executeCommand("emacsclient -e '(popup-frame-org-capture)'")
        end,
        ["F9"] = function()
            util:executeCommand("emacsclient -e '(popup-frame-save-bookmark)'")
        end,
    },
    blackList = {
        "org.hammerspoon.Hammerspoon",
        "com.apple.notificationcenterui",
        "im.rime.inputmethod.Squirrel",
    },
    inputMethod = {
        "com.github.wez.wezterm",
        "com.jetbrains.intellij",
        "com.jetbrains.datagrip",
        "org.gnu.Emacs",
        "org.hammerspoon.Hammerspoon",
        "com.eusoft.eudic",
    },
}
return conf
