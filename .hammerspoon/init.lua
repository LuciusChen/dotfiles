local lVer = _VERSION:match("Lua (.+)$")
-- specify luarocks path yourself if this doesn't find it in the normal places
local luarocks = "/usr/local/bin/luarocks"
if #luarocks > 0 then
    package.path = package.path .. ";" .. hs.execute(
            luarocks .. " --lua-version " .. lVer .. " path --lr-path"
        ):gsub("\n", "")
    package.cpath = package.cpath .. ";" .. hs.execute(
            luarocks .. " --lua-version " .. lVer .. " path --lr-cpath"
        ):gsub("\n", "")
end

require 'moonscript'
require 'main'