executeCommand=(eventType, profile)->
  if (eventType == "added") then
      hs.alert.show("Keyboard detected.")
      hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile " .. profile)
  elseif (eventType == "removed") then
      hs.alert.show("Keyboard removed.")
      hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile ")

hs.usb.watcher.new((data) -> 
  if (data["productName"] == "HHKB Professional") then
      executeCommand(data["eventType"], "⌨️")
  elseif (data["productName"] == "IFKB 2.4G REC (STM)") then
      executeCommand(data["eventType"], "🪽")
)\start!