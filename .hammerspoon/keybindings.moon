--- === HSKeybindings ===
--- Display Keybindings registered with bindHotkeys() and Spoons 
_ = require 'lodash'

appMap =
  w: 'Telegram'
  s: 'WeChat'
  x: 'QQ'
  e: 'Intellij IDEA'
  d: 'Datagrip'
  c: 'iTerm2'
  r: 'Tweetbot'
  f: 'Finder'
  v: 'VSCode'
  t: 'Things'
  g: 'Chrome'
  b: 'PDF Expert'
  y: 'Spotify'
  h: 'WeWork'
  n: 'Bear'
  u: 'Spark'
  j: 'Affinity Designer'
  m: 'Postman'
  i: 'MindNode'
  k: 'Surge'
  o: 'Capture One'
  l: 'DaVinci Resolve'
  p: 'Photoshop'

-- funtionMap =
--   [9]: 'play or pause'

processHotkeys= ->
  menu = ""
  _.forEach appMap, (v, k) ->
    menu = menu .. "<ul class='col col" .. k .. "'><li><div class='cmdtext'>" .. " " .. v .. "</div></li></ul>"
--   _.forEach funtionMap, (v, k) ->
--     menu = menu .. "<ul class='col col" .. k .. "'><li><div class='cmdtext'>" .. " " .. v .. "</div></li></ul>"
  return menu

generateHtml= ->
  app_title = "Hammerspoon Keybindings"
  allmenuitems = processHotkeys!
  html = [[
        <!DOCTYPE html>
        <html>
        <head>
        <style type="text/css">
            *{margin:0; padding:0;}
            html, body{
              background-color:#eee;
              font-family: arial;
              font-size: 13px;
            }
            a{
              text-decoration:none;
              color:#000;
              font-size:12px;
            }
            li.title{ text-align:center;}
            ul, li{list-style: inside none; padding: 0 0 5px;}
            footer{
              position: fixed;
              left: 0;
              right: 0;
              height: 48px;
              background-color:#eee;
            }
            header{
              position: fixed;
              top: 0;
              left: 0;
              right: 0;
              height:48px;
              background-color:#eee;
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
              padding: 0 0 15px;
              font-size:12px;
              overflow:hidden;
              background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='300' fill='%23cccccc' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3E⌘⌃⌥%3C/text%3E%3C/svg%3E");
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
            .content > .colm{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EM%3C/text%3E%3C/svg%3E");
            }
            .content > .coln{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EN%3C/text%3E%3C/svg%3E");
            }
            .content > .colb{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EB%3C/text%3E%3C/svg%3E");
            }
            .content > .colv{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EV%3C/text%3E%3C/svg%3E");
            }
            .content > .colc{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EC%3C/text%3E%3C/svg%3E");
            }
            .content > .colx{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EX%3C/text%3E%3C/svg%3E");
            }
            .content > .coll{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EL%3C/text%3E%3C/svg%3E");
            }
            .content > .colk{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EK%3C/text%3E%3C/svg%3E");
            }
            .content > .colj{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EJ%3C/text%3E%3C/svg%3E");
            }
            .content > .colh{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EH%3C/text%3E%3C/svg%3E");
            }
            .content > .colg{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EG%3C/text%3E%3C/svg%3E");
            }
            .content > .colf{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EF%3C/text%3E%3C/svg%3E");
            }
            .content > .cold{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ED%3C/text%3E%3C/svg%3E");
            }
            .content > .cols{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ES%3C/text%3E%3C/svg%3E");
            }
            .content > .colp{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EP%3C/text%3E%3C/svg%3E");
            }
            .content > .colo{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EO%3C/text%3E%3C/svg%3E");
            }
            .content > .coli{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EI%3C/text%3E%3C/svg%3E");
            }
            .content > .colu{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EU%3C/text%3E%3C/svg%3E");
            }
            .content > .coly{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EY%3C/text%3E%3C/svg%3E");
            }
            .content > .colt{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ET%3C/text%3E%3C/svg%3E");
            }
            .content > .colr{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3ER%3C/text%3E%3C/svg%3E");
            }
            .content > .cole{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EE%3C/text%3E%3C/svg%3E");
            }
            .content > .colw{
                content: '';
                display: block;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg'%3E%3Ctext x='50%25' y='50%25' font-size='60' fill='%23e15151' font-family='system-ui, sans-serif' text-anchor='middle' dominant-baseline='middle'%3EW%3C/text%3E%3C/svg%3E");
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
            }
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

--- HSKeybindings:hide()
--- Method
--- Hide the cheatsheet webview
---
--- Parameters:
---  * None
---

  hide: =>
    @sheetView\hide!

  toggle: =>
    if @sheetView and @sheetView\hswindow! and @sheetView\hswindow!\isVisible! then
      @hide!
    else
      @show!
keybindings


