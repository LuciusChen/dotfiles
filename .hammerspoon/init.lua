package.path = '/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;'..package.path
package.cpath = '/usr/local/lib/lua/5.3/?.so;'..package.cpath

hs.hotkey.bind('cmd-alt-ctrl', '\\', nil, function()
  hs.notify.show('Hammerspoon', '配置', '重载')
  hs.reload()
end)

require 'moonscript'
require 'main'
-- copy from xream https://github.com/xream/.hammerspoon
-- security add-generic-password -s hammerspoon -a system -w password
-- brew install homebrew/versions/lua53
-- luarocks install moonscript
-- luarocks install moses
