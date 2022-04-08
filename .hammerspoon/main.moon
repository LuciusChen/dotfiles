conf = require 'conf'
_ = require 'lodash'

_.forEach conf.moudle, (v, k) ->
  require k if v

-- "clipboard History" and "Emojis" dependent on "SpoonInstall"
hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall\andUse('TextClipboardHistory', {config: {show_in_menubar: false}, hotkeys: {toggle_clipboard: {conf.hyper, "3" }}, start: true})
spoon.SpoonInstall\andUse('Emojis')
spoon.Emojis\bindHotkeys({toggle: {conf.hyper, "2" }})

-- ignore system shortcuts
noop= ->
-- conf.bind({ 'cmd' }, 'h', noop)
conf.bind({ 'cmd', 'alt' }, 'h', noop)
conf.bind(conf.hyperPlus, 'i', noop)