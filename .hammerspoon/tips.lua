-- === Keybindings ===
--- Display Keybindings registered with bindHotkeys() and Spoons
local conf = require("conf")

appMap = {
    w = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EW%3C/text%3E%3C/svg%3E",
    },
    s = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ES%3C/text%3E%3C/svg%3E",
    },
    x = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EX%3C/text%3E%3C/svg%3E",
    },
    e = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EE%3C/text%3E%3C/svg%3E",
    },
    d = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ED%3C/text%3E%3C/svg%3E",
    },
    c = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EC%3C/text%3E%3C/svg%3E",
    },
    r = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ER%3C/text%3E%3C/svg%3E",
    },
    f = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EF%3C/text%3E%3C/svg%3E",
    },
    v = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EV%3C/text%3E%3C/svg%3E",
    },
    t = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ET%3C/text%3E%3C/svg%3E",
    },
    g = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EG%3C/text%3E%3C/svg%3E",
    },
    b = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EB%3C/text%3E%3C/svg%3E",
    },
    y = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EY%3C/text%3E%3C/svg%3E",
    },
    h = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EH%3C/text%3E%3C/svg%3E",
    },
    n = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EN%3C/text%3E%3C/svg%3E",
    },
    u = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EU%3C/text%3E%3C/svg%3E",
    },
    j = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EJ%3C/text%3E%3C/svg%3E",
    },
    m = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EM%3C/text%3E%3C/svg%3E",
    },
    i = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EI%3C/text%3E%3C/svg%3E",
    },
    k = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EK%3C/text%3E%3C/svg%3E",
    },
    o = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EO%3C/text%3E%3C/svg%3E",
    },
    l = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EL%3C/text%3E%3C/svg%3E",
    },
    p = {
        app = "",
        SVG = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EP%3C/text%3E%3C/svg%3E",
    },
}

local function forEach(tbl, func)
    for k, v in pairs(tbl) do
        func(v, k)
    end
end

forEach(conf.appMap, function(v, k)
    forEach(appMap, function(_v, _k)
        if k == _k then
            local appName = hs.application.nameForBundleID(v)
            if appName ~= nil then
                _v.app = appName
            end
        end
    end)
end)

local function processHotkeys()
    local menu = ""
    forEach(appMap, function(v, k)
        if v.app ~= nil and v.app ~= "" then
            menu = menu
                .. "<ul class='col col"
                .. k
                .. "'><li><div class='cmdtext cmdtext"
                .. k
                .. "'>"
                .. " "
                .. v.app
                .. "</div></li></ul>"
        end
    end)
    return menu
end

local function processHotkeysCSS()
    local css = ""
    forEach(appMap, function(v, k)
        if v.app ~= nil and v.app ~= "" then
            css = css
                .. ".content > .col"
                .. k
                .. "{ content: ''; display: inline-block; background-image: url(\""
                .. v.SVG
                .. '");}'
        end
    end)
    return css
end

local function generateHtml()
    local allmenuitems = processHotkeys()
    local allCSS = processHotkeysCSS()
    -- === light mode ===
    -- local background_color = "#eee"
    -- local font_color = "#000"
    -- local background_img = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='350' fill='%23cccccc' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3E⌘⌃⌥%3C/text%3E%3C/svg%3E"
    -- === dark mode ===
    local background_color = "#020202"
    local font_color = "#fff"
    local background_img =
        "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='300' fill='%23666666' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3E⌘⌃⌥%3C/text%3E%3C/svg%3E"
    local html = [[
        <!DOCTYPE html>
        <html>
        <head>
        <style type="text/css">
            *{margin:0; padding:0;}
            html, body{
              background-color: ]] .. background_color .. [[;
              font-family: arial;
              font-size: 13px;
              color: ]] .. font_color .. [[;
            }
            a{
              text-decoration:none;
              color: ]] .. font_color .. [[;
              font-size:12px;
            }
            li.title{ text-align:center;}
            ul, li{list-style: inside none; padding: 0 0 5px;}
            header{
              position: fixed;
              top: 0;
              left: 0;
              right: 0;
              height:48px;
              background-color: ]] .. background_color .. [[;
              z-index:99;
            }
            footer{ bottom: 0;
                padding:20px 20px 20px 20px;
             }
            header hr,
            footer hr {
              border: 0;
              height: 0;
              border-top: 1px solid rgba(0, 0, 0, 0.1);
              border-bottom: 1px solid rgba(255, 255, 255, 0.3);
            }
            .title{
                padding: 15px;
            }
            li.title{padding: 0  10px 15px}
            .content{
              padding: 15px 0 15px;
              font-size:12px;
              overflow:hidden;
              background-image: url("]] .. background_img .. [[");
            }
            .content.maincontent{
            position: relative;
              height: 577px;
              margin-top: 46px;
            }
            .content > .col{
              width: 23%;
              padding:20px 0 20px 20px;
            }
            li:after{
              visibility: hidden;
              display: block;
              font-size: 0;
              content: " ";
              clear: both;
              height: 0;
            }
            .cmdtext{
              float: left;
              overflow: hidden;
              width: 100%;
              text-align: center;
              font-size: 25px;
              font-weight: 900;
              color: #eeeeee;
            }
            ]] .. allCSS .. [[
        </style>
        </head>
          <body>
            <div class="content maincontent">]] .. allmenuitems .. [[</div>
            <br>
          <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.isotope/2.2.2/isotope.pkgd.min.js"></script>
            <script type="text/javascript">
              var elem = document.querySelector('.content');
              var iso = new Isotope( elem, {
                // options
                itemSelector: '.col',
                layoutMode: 'masonry'
              });
            </script>
          </body>
        </html>
    ]]
    return html
end

tips = {
    init = function(self)
        self.sheetView = hs.webview.new({ x = 0, y = 0, w = 0, h = 0 })
        self.sheetView:windowTitle("HSKeybindings")
        self.sheetView:windowStyle("utility")
        self.sheetView:allowGestures(true)
        self.sheetView:allowNewWindows(false)
        self.sheetView:level(hs.drawing.windowLevels.modalPanel)
    end,
    show = function(self)
        local cscreen = hs.screen.mainScreen()
        local cres = cscreen:fullFrame()
        self.sheetView:frame({
            x = cres.x + cres.w * 0.2,
            y = cres.y + cres.h * 0.25,
            w = cres.w * 0.6,
            h = cres.h * 0.55,
        })
        local webcontent = generateHtml()
        self.sheetView:html(webcontent)
        self.sheetView:show()
    end,
    hide = function(self)
        self.sheetView:hide()
    end,
    toggle = function(self)
        if self.sheetView and self.sheetView:hswindow() and self.sheetView:hswindow():isVisible() then
            self:hide()
        else
            self:show()
        end
    end,
}

return tips
