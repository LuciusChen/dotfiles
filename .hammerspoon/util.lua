local mouse = require("mouse")
util = {
    includes = function(self, tbl, item)
        for _, value in pairs(tbl) do
            if value == item then
                return true
            end
        end
        return false
    end,
    toggle = function(self, id, maximize)
        local app = hs.application.frontmostApplication()
        if app:bundleID() == id then
            return app:hide()
        else
            hs.application.launchOrFocusByBundleID(id)
            if maximize then
                self:win():minimize()
            end
            return mouse:frontmost()
        end
    end,
    notify = function(self, title, text)
        return hs.notify.new({ title = title, informativeText = text }):send()
    end,
    trim = function(self, str)
        return string.gsub(str, "^%s*(.-)%s*$", "%1")
    end,
    reload = function(self)
        self:notify("Configuration", "Reload")
        return hs.reload()
    end,
    merge = function(t1, t2)
        for k, v in ipairs(t2) do
            table.insert(t1, v)
        end
        return t1
    end,
    tableMerge = function(self, a, b)
        if type(a) == "table" and type(b) == "table" then
            for k, v in pairs(b) do
                if type(v) == "table" and type(a[k] or false) == "table" then
                    self:tableMerge(a[k], v)
                else
                    a[k] = v
                end
            end
        end
        return a
    end,
    split = function(s, delimiter)
        local result = {}
        for match in (s .. delimiter):gmatch("([^.]*)" .. delimiter) do
            table.insert(result, match)
        end
        return result
    end,
}
return util
