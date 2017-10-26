--package.path = '/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;'..package.path
--package.cpath = '/usr/local/lib/lua/5.3/?.so;'..package.cpath

hs.hotkey.bind('cmd-alt-ctrl', '\\', nil, function()
  hs.notify.show('Hammerspoon', '配置', '重载')
  hs.reload()
end)

require 'moonscript'
require 'main'
