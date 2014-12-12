-- This action sends email when the cameras are not recording for given time
-- Use trigger "System variables updated" in the IPCorder Action Editor

-- initialization
if ownDevice == nil then ownDevice = {}; end;	-- initialize custom device table if not exists
if startTime == nil then startTime = os.time(); end; -- stores initial action timestamp
now = os.time();	-- stores current time
reportLine = "";
reportBody = "";

-- CHANGE CHECK INTERVAL BELLOW in seconds, eg. 5days ... 5x24x60x60=432000 seconds
local checkInterval = 86400;							

-- main loop
for name,dev in pairs(devices) do
  if (dev.recording == false) and (ownDevice[name] == nil) then ownDevice[name] = tostring(startTime);	-- append initial timestamp for cameras which doesn't start recording yet
  elseif (dev.recording == true) or (dev.recording == nil) then ownDevice[name] = tostring(now); 	-- append current timestamp if recording is TRUE on the current camera or NIL for system device
  end
  
  if (now - ownDevice[name]) > checkInterval then 				-- statement for recording check
    reportLine = "WARNING: Camera " .. name .. " is not recording for " .. checkInterval .. " seconds." .. "\n"; 	-- make the email report item
    reportBody = reportBody .. reportLine; -- concat of the email body
    ownDevice[name] = tostring(now); -- reset timer after append to the email report
  end

-- logf("name=%s, timestamp=%s", name, ownDevice[name]); -- debug only can be commented out
end

-- sends the email report
-- CHANGE EMAIL ADDRESS BELLOW
if reportBody ~= "" then mail("someone@some.where", "Some devices has no recording yet, timestamp ${now}",  "${reportBody}"); end;
