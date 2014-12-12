-- Performs a shutdown of IPCorder when blackout occures. It assumes IPCorder connected to UPS unit and other device which is not connected to UPS
-- Use trigger "System variables updated" in the IPCorder Action Editor

deviceAddress = "192.168.0.10"; -- device on your network which is not connected to UPS
interval = 1800; -- timeout after blackout in seconds, eg 30min x60=1800sec

now = os.time();

local function pingChecker(o)
  if o.success then 
     successTime=now; 
     --logf("ping OK, timestamp: %d", successTime); -- debug only
  else 
     failTime=now; 
     --logf("ping KO, timestamp: %d", failTime);  -- debug only
  end
  if ((failTime-successTime) > interval) then 
    log("Shutdown action triggered");
    devices.system.Shutdown();
  end
end

ping{address=deviceAddress, timeout = 2; callback=pingChecker}
