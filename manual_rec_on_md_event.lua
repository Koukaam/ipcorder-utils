-- Use trigger event "Motion detected" of single Device (camera) in the IPCorder Action Editor

devices[event.device].AddNote{note="Motion Detected"};

interval = 15 -- MD record interval in seconds

initialMD = os.time();

if devices[event.device].manualRecording == false then
  devices[event.device].AddNote{note="Manual recording started"};
  devices[event.device].ManualRecordingStart(); -- start of manual recording
end;

function checkMD()
  if ((os.time() - initialMD) < interval) then -- check if new MDs are comming
    -- devices[event.device].AddNote{note="MDs are still comming"};
  else
    devices[event.device].AddNote{note="Manual recording stopped"};
    devices[event.device].ManualRecordingStop(); -- end of manual recoring
  end;
end;

delay(interval, function() checkMD(); end);
