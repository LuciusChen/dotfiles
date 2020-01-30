-- http://github.com/dbmrq/dotfiles/

-- Cherry tomato (a tiny Pomodoro)


-----------------------------
--  Customization Options  --
-----------------------------

-- Set these variables to whatever you prefer

-- The keyboard shortcut to start the timer is composed of the `super`
-- modifiers + the `hotkey` value.

super = {"ctrl", "alt", "cmd"}
hotkey = "1"

duration = 1 -- timer duration in minutes

-- set this to true to always show the menu bar item
-- (making the keyboard shortcut superfluous):
alwaysShow = false


-------------------------------------------------------------------
--  Don't mess with this part unless you know what you're doing  --
-------------------------------------------------------------------
updateTimer = nil
updateMenu = nil
start = nil
pause = nil
reset = nil
stop = nil
menu = nil
isActive = false

timeLeft = duration * 60

updateMenu = () ->
  if not menu
    menu = hs.menubar.new()
    menu\setTooltip("Cherry")
  menu\returnToMenuBar!
  minutes = math.floor(timeLeft / 60)
  seconds = timeLeft - (minutes * 60)
  string = string.format("%02d:%02d 🙄️", minutes, seconds)
  menu\setTitle(string)
  items = {{title:"Stop", fn:()-> stop!},}
  if isActive
    table.insert(items, 1, {title:"Pause", fn:()-> pause!})
  else
    table.insert(items, 1, {title:"Start", fn:()-> start!})
  -- print(items[1].fn)
  menu\setMenu(items)

updateTimer = () ->
    if not isActive
      return
    timeLeft = timeLeft - 1
    updateMenu!
    if timeLeft <= 0
        stop!
        hs.alert.show("Done! 🍒")

timer = hs.timer.new(1, () -> updateTimer!)

start = () ->
  if isActive
    return
  timer\start!
  isActive = true

pause = () ->
  if not isActive
    return
  timer\stop!
  isActive = false
  updateMenu!

stop = () ->
  pause!
  timeLeft = duration * 60
  if not alwaysShow
    menu\delete!
  else
    updateMenu!

reset = () ->
  timeLeft = duration * 60
  updateMenu!

hs.hotkey.bind(super, hotkey, () -> start!)

if alwaysShow
  updateMenu!