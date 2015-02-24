-- Performs a shutdown of IPCorder when incomming CGI arrives
-- it uses password for unwanted shutdowns
-- use trigger "Incomming CGI event" in the IPCorder Action Editor
-- use following URI in your browser http://<ipc_ip>/event?pass=password

local accepted_pass="password"
local pass=event.args.pass
if (pass==accepted_pass) then
	devices.system.Shutdown();
else
	log("CGI parser: Wrong password")
end
