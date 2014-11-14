-- Use Activation by Button event "Manual (triggered by action button)"

if (status == 0 or status == nil) then
  status = 2;
  log("Button ON"); 
  -- place your ON action here; 
  -- devices.test.AdminCGI{path="/cgi-bin/admin/setparam.cgi?ircutcontrol_disableirled=1"};
end
if status == 1 then
  log("Button OFF");
  status = 0;
  -- place your OFF action here;
  -- devices.test.AdminCGI{path="/cgi-bin/admin/setparam.cgi?ircutcontrol_disableirled=0"};
end
if status == 2 then
  status = 1;
end
