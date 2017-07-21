package.path = '/usr/local/share/lua/5.2/?.lua;/usr/local/share/lua/5.2/?/init.lua;'..package.path
package.cpath = '/usr/local/lib/lua/5.2/?.so;'..package.cpath

hs.hotkey.bind('cmd-alt-ctrl', '\\', nil, function()
  hs.notify.show('Hammerspoon', '配置', '重载')
  hs.reload()
end)

require 'moonscript'
require 'main'
