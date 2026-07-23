--!nonstrict

local interface = ""
local lastRx = nil
local lastTx = nil
local rxSpeed = 0
local txSpeed = 0

local function isPhysicalInterface(name)
  return string.match(name, "^en") ~= nil
    or string.match(name, "^eth") ~= nil
    or string.match(name, "^wl") ~= nil
end

local function defaultInterface()
  local routes = noctalia.readFile("/proc/net/route")
  if not routes then
    return interface
  end

  local best = ""
  local bestMetric = math.huge
  for line in string.gmatch(routes, "[^\r\n]+") do
    local name, destination, gateway, flags, refCount, useCount, metric =
      string.match(line, "^(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
    if name and destination == "00000000" and isPhysicalInterface(name) then
      local numericMetric = tonumber(metric) or math.huge
      if numericMetric < bestMetric then
        best = name
        bestMetric = numericMetric
      end
    end
  end

  if best ~= "" then
    return best
  end
  return interface ~= "" and interface or "enp0s31f6"
end

local function counter(name, direction)
  local value = noctalia.readFile(
    "/sys/class/net/" .. name .. "/statistics/" .. direction .. "_bytes"
  )
  return tonumber(value or "")
end

local function formatSpeed(bytes)
  if bytes >= 1024 * 1024 * 1024 then
    return string.format("%.1fG/s", bytes / (1024 * 1024 * 1024))
  elseif bytes >= 1024 * 1024 then
    return string.format("%.1fM/s", bytes / (1024 * 1024))
  elseif bytes >= 1024 then
    return string.format("%.0fK/s", bytes / 1024)
  end
  return string.format("%.0fB/s", bytes)
end

local function render()
  local container = barWidget.isVertical() and ui.column or ui.row
  local glyph = string.match(interface, "^wl") and "wifi" or "ethernet"

  barWidget.render(container({ gap = 5, align = "center" }, {
    ui.glyph({ name = glyph, size = 14 }),
    ui.glyph({ name = "arrow-down", size = 10, color = "secondary" }),
    ui.label({ text = formatSpeed(rxSpeed) }),
    ui.glyph({ name = "arrow-up", size = 10, color = "primary" }),
    ui.label({ text = formatSpeed(txSpeed) }),
  }))

  barWidget.setTooltip(
    interface .. "\n↓ " .. formatSpeed(rxSpeed) .. "   ↑ " .. formatSpeed(txSpeed)
  )
end

function update()
  noctalia.setUpdateInterval(1000)

  local active = defaultInterface()
  if active ~= interface then
    interface = active
    lastRx = nil
    lastTx = nil
  end

  local rx = counter(interface, "rx")
  local tx = counter(interface, "tx")
  if rx and tx then
    if lastRx and lastTx then
      rxSpeed = math.max(0, rx - lastRx)
      txSpeed = math.max(0, tx - lastTx)
    end
    lastRx = rx
    lastTx = tx
  end

  render()
end

function onClick()
  noctalia.runAsync("noctalia msg panel-toggle control-center network")
end
