conf = {
    debug = true,
    securityAgentWhiteList = { "System Preferences" },
    hyper = "⌘⌃⌥",
    hyperPlus = "⌘⌃⌥⇧",
    bind = hs.hotkey.bind,
    appMap = {
        w = "ru.keepcoder.Telegram",
        s = "com.tencent.xinWeChat",
        x = "com.openai.codex",
        e = "com.jetbrains.intellij",
        d = "com.jetbrains.datagrip",
        c = "net.kovidgoyal.kitty",
        r = "org.gnu.Emacs",
        f = "com.apple.finder",
        v = "com.microsoft.VSCode",
        t = "com.calibre-ebook.ebook-viewer",
        g = "company.thebrowser.dia",
        b = "info.sioyek.sioyek",
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
        p = "md.obsidian",
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
        ["left"] = "leftHalf",
        ["right"] = "rightHalf",
        ["up"] = "toggle",
        ["down"] = "centerHalf",
        ["["] = "preScreen",
        ["]"] = "nextScreen",
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
    },
    blackList = {
        "org.hammerspoon.Hammerspoon",
        "com.apple.notificationcenterui",
        "im.rime.inputmethod.Squirrel",
    },
}
return conf
