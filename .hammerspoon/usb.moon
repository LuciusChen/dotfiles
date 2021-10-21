hs.usb.watcher.new((data) -> 
  -- print(data["productID"] )
  if (data["productName"] == "HHKB Professional") then
    if (data["eventType"] == "added") then
      hs.alert.show("Keyboard detected.")
      hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile ⌨️")
    elseif (data["eventType"] == "removed") then
      hs.alert.show("Keyboard removed.")
      hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile ")
)\start!