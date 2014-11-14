-- Use Activation by Button event "Manual (triggered by action button)"

logf("-----")
local function toDebugString(a, indent)
		if type(a) == 'table' then
			indent = indent or 0
			local out = {'table\n'}
			for k, v in pairs(a) do
				table.insert(out, string.format('%s%s -> %s\n', string.rep('   ', indent), tostring(k), toDebugString(v, indent+1)))
			end
			return table.concat(out)
		else
			return tostring(a)
		end
end 

for key, item in pairs(devices) do
      logf("%s -> %s", key, toDebugString(item, 0))
end
