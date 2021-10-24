--- === Keybindings ===
--- Display Keybindings registered with bindHotkeys() and Spoons 
_ = require 'lodash'

appMap =
  w:
    'app': 'Telegram',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EW%3C/text%3E%3C/svg%3E"
  s: 
    'app': 'WeChat',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ES%3C/text%3E%3C/svg%3E"
  x: 
    'app': 'QQ',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EX%3C/text%3E%3C/svg%3E"
  e: 
    'app': 'Intellij IDEA',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EE%3C/text%3E%3C/svg%3E"
  d: 
    'app': 'DataGrip',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ED%3C/text%3E%3C/svg%3E"
  c: 
    'app': 'iTerm2',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EC%3C/text%3E%3C/svg%3E"
  r: 
    'app': 'Tweetbot',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ER%3C/text%3E%3C/svg%3E"
  f: 
    'app': 'Finder',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EF%3C/text%3E%3C/svg%3E"
  v: 
    'app': 'VSCode',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EV%3C/text%3E%3C/svg%3E"
  t: 
    'app': 'Things',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ET%3C/text%3E%3C/svg%3E"
  g: 
    'app': 'Chrome',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EG%3C/text%3E%3C/svg%3E"
  b: 
    'app': 'PDF Expert',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EB%3C/text%3E%3C/svg%3E"
  y: 
    'app': 'Spotify',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EY%3C/text%3E%3C/svg%3E"
  h: 
    'app': 'WeWork',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EH%3C/text%3E%3C/svg%3E"
  n: 
    'app': 'Bear',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EN%3C/text%3E%3C/svg%3E"
  u: 
    'app': 'Spark',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EU%3C/text%3E%3C/svg%3E"
  j: 
    'app': 'Affinity Designer',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EJ%3C/text%3E%3C/svg%3E"
  m: 
    'app': 'Postman',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EM%3C/text%3E%3C/svg%3E"
  i: 
    'app': 'MindNode',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EI%3C/text%3E%3C/svg%3E"
  k: 
    'app': 'Surge',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EK%3C/text%3E%3C/svg%3E"
  o: 
    'app': 'Capture One',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EO%3C/text%3E%3C/svg%3E"
  l: 
    'app': 'DaVinci Resolve',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EL%3C/text%3E%3C/svg%3E"
  p: 
    'app': 'PhotoShop',
    'SVG': "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EP%3C/text%3E%3C/svg%3E"

-- funtionMap =
--   [9]: 'play or pause'

processHotkeys= ->
  menu = ""
  _.forEach appMap, (v, k) ->
    menu = menu .. "<ul class='col col" .. k .. "'><li><div class='cmdtext'>" .. " " .. v.app .. "</div></li></ul>"
  return menu

processHotkeysCSS= ->
  css = ""
  _.forEach appMap, (v, k) ->
    css = css .. ".content > .col" .. k .. "{ content: ''; display: inline-block; background-image: url(\"" .. v.SVG .. "\");}"
  return css

generateHtml= ->
  app_title = "Hammerspoon Keybindings"
  allmenuitems = processHotkeys!
  allCSS = processHotkeysCSS!
  print(allCSS)
  -- === light mode ===
  -- background_color = "#eee"
  -- font_color = "#000"
  -- background_img = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='350' fill='%23cccccc' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3E⌘⌃⌥%3C/text%3E%3C/svg%3E"
  -- === dark mode ===
  background_color = "#282c34"
  font_color = "#fff"
  background_img = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='300' fill='%23666666' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3E⌘⌃⌥%3C/text%3E%3C/svg%3E"
  html = [[
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
              color:#000;
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
              width: 165px;
              text-align: center;
              font-size: 20px;
              font-weight: 900;
            }
            ]] .. allCSS ..[[
        </style>
        </head>
          <body>
            <header>
              <div class="title"><strong>]] .. app_title .. [[</strong></div>
              <hr />
            </header>
            <div class="content maincontent">]] .. allmenuitems .. [[</div>
            <br>

          <footer>
          </footer>
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



keybindings = 
  init: =>
    @sheetView = hs.webview.new({x:0, y:0, w:0, h:0})
    @sheetView\windowTitle("HSKeybindings")
    @sheetView\windowStyle("utility")
    @sheetView\allowGestures(true)
    @sheetView\allowNewWindows(false)
    @sheetView\level(hs.drawing.windowLevels.modalPanel)

  show: =>
    cscreen = hs.screen.mainScreen!
    cres = cscreen\fullFrame!
    @sheetView\frame({
        x: cres.x+cres.w*0.2,
        y: cres.y+cres.h*0.25,
        w: cres.w*0.6,
        h: cres.h*0.5
    })
    webcontent = generateHtml!
    @sheetView\html(webcontent)
    @sheetView\show!

  hide: =>
    @sheetView\hide!

  toggle: =>
    if @sheetView and @sheetView\hswindow! and @sheetView\hswindow!\isVisible! then
      @hide!
    else
      @show!
keybindings


