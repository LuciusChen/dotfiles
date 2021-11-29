--- === Emojis ===
---
--- Let users choose emojis by name/keyword
local obj = {}
obj.__index = obj

-- luacheck: globals utf8

-- Metadata
obj.name = "Emojis"
obj.version = "1.0"
obj.author = "Adriano Di Luzio <adrianodl@hotmail.it>"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Internal function used to find our location, so we know where to load files from

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end

local function linkImg(choices)
    for _, ch in pairs(choices) do
        if ch["image_path"] then
            ch["image"] = hs.image.imageFromPath(obj.spoonPath .. "/emojis/png/" .. ch["image_path"] .. ".png")
        end
    end
end
-- query change callback function
local function queryChangedCallback(query)
    local choicesLocal = {}
    local result = {}
    if query:find("^all") ~= nil then
        choicesLocal = obj.choices
        query = string.sub(query, 4)
        obj.chooser:choices(obj.choices)
        obj.choicesFlag = true
    else
        obj.choicesFlag = false
        choicesLocal = obj.choicesFrequently
        obj.chooser:choices(obj.choicesFrequently)
    end
    
    for _, ch in pairs(choicesLocal) do
        if string.find(ch["subText"], query) or string.find(ch["text"], query) then
            table.insert(
                result,
                {
                    text = ch["text"],
                    subText = ch["subText"],
                    image_path = ch["image_path"],
                    image = ch["image"],
                    char = ch["char"],
                    order = ch["order"]
                }
            )
        end
    end
    
    table.sort(
            result,
            function(a, b)
                return a["order"] < b["order"]
            end
        )
    if next(result) then
        obj.chooser:choices(result)
    end
end

obj.spoonPath = script_path()

obj.choices = {}
obj.choicesFrequently = {}
obj.choicesFlag = false
obj.chooser = nil
obj.hotkey = nil

dofile(obj.spoonPath .. "/table.lua")

local wf = hs.window.filter.defaultCurrentSpace

function obj.callback(choice)
    local lastFocused = wf:getWindows(wf.sortByFocusedLast)
    if #lastFocused > 0 then
        lastFocused[1]:focus()
    end
    if not choice then
        return
    end
    assert(choice.char)
    if obj.choicesFlag then
        print("Starting add Emoji to emojis_json_lua_frequently.lua...")
        local mod, err = table.load(script_path() .. "emojis_json_lua.lua") -- luacheck: ignore
        local modFrequently, errFrequently = table.load(script_path() .. "emojis_json_lua_frequently.lua") -- luacheck: ignore
        obj.choicesFrequently = {}
        for _, ch in pairs(mod) do
            if ch["image_path"] == choice.image_path then
                table.insert(
                    obj.choicesFrequently,
                    {
                        text = ch["text"],
                        subText = ch["subText"],
                        image_path = ch["image_path"],
                        char = ch["char"],
                        order = ch["order"]
                    }
                )
            end
        end

        if not errFrequently then
            for _, ch in pairs(modFrequently) do
                if ch["image_path"] ~= choice.image_path then
                    table.insert(
                        obj.choicesFrequently,
                        {
                            text = ch["text"],
                            subText = ch["subText"],
                            image_path = ch["image_path"],
                            char = ch["char"],
                            order = ch["order"]
                        }
                    )
                end
            end
        end

        table.sort(
                obj.choicesFrequently,
                function(a, b)
                    return a["order"] < b["order"]
                end
            )
        linkImg(obj.choicesFrequently)
        os.remove(obj.spoonPath .. "/emojis_json_lua_frequently.lua")
        table.save(obj.choicesFrequently, obj.spoonPath .. "/emojis_json_lua_frequently.lua") -- luacheck: ignore
        print("Emoji to emojis_json_lua_frequently.lua saved...")
    end
    hs.eventtap.keyStrokes(hs.utf8.codepointToUTF8(table.unpack(choice.char))) -- luacheck: ignore
end

function obj:init()
    -- is the emojis file available?
    print("Starting Emojis Spoon...")
    local mod, err = table.load(script_path() .. "emojis_json_lua.lua") -- luacheck: ignore
    local modFrequently, errFrequently = table.load(script_path() .. "emojis_json_lua_frequently.lua") -- luacheck: ignore
    if err then
        print("Emojis Spoon: table's not here, generating it from json.")
        mod = nil
    end
    if mod then
        self.choices = mod
    else
        self.choices = {}
        for _, emoji in pairs(hs.json.decode(io.open(self.spoonPath .. "/emojis/emojis.json"):read())) do
            local subText = emoji.shortname
            if #emoji.keywords > 0 then
                subText = table.concat(emoji["keywords"], ", ") .. ", " .. subText
            end
            local chars =
                hs.fnutils.imap(
                hs.fnutils.split(emoji.code_points.output, "-"),
                function(s)
                    return tonumber(s, 16)
                end
            )

            table.insert(
                self.choices,
                {
                    text = emoji["name"]:gsub("^%l", string.upper),
                    subText = subText,
                    image_path = emoji["code_points"]["base"],
                    -- image = hs.image.imageFromPath(
                    --     self.spoonPath .. "/emojis/png/" .. emoji["code_points"]["base"] .. ".png"
                    -- ),
                    char = chars,
                    order = tonumber(emoji["order"])
                }
            )
        end
        table.sort(
            self.choices,
            function(a, b)
                return a["order"] < b["order"]
            end
        )

        print("Emojis Spoon: Saving emojis... ")
        table.save(self.choices, self.spoonPath .. "/emojis_json_lua.lua") -- luacheck: ignore
        print("Emojis Spoon: ... saved")
    end

    self.chooser = hs.chooser.new(self.callback)
    self.chooser:rows(10)
    self.chooser:searchSubText(true)
    self.chooser:queryChangedCallback(queryChangedCallback)

    self.choices = mod
    -- inject all images now
    linkImg(obj.choices)

    if not errFrequently then
        self.choicesFrequently = modFrequently
        linkImg(obj.choicesFrequently)
        obj.chooser:choices(obj.choicesFrequently)
    end
    print("Emojis Spoon: Startup completed")
end

--- Emojis:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for Emojis
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * toggle - This will toggle the emoji chooser
---
--- Returns:
---  * The Emojis object
function obj:bindHotkeys(mapping)
    if self.hotkey then
        self.hotkey:delete()
    end
    local toggleMods = mapping["toggle"][1]
    local toggleKey = mapping["toggle"][2]

    self.hotkey =
        hs.hotkey.new(
        toggleMods,
        toggleKey,
        function()
            if self.chooser:isVisible() then
                self.chooser:hide()
            else
                self.chooser:show()
            end
        end
    ):enable()

    return self
end

return obj
