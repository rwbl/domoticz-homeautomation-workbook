--[[
    alertmsg_monitor.lua
    If level (nValue) of the Alert Messages device > threshold (set by uservarable TH_ALERTTOEMAIL) , then send email notification.
    Project: atHome
    Interpreter: dzVents, Timer
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190708
]]--

-- Idx of the devices used
local IDX_ALERTMSG = 55
local IDX_TH_ALERTTOEMAIL = 14

return {
    -- Check which device(s) have a state change
	on = {
		devices = { IDX_ALERTMSG }
	},
    -- Handle the switch if its state has changed to On
	execute = function(domoticz, device)
		domoticz.log('Device ' .. device.name .. ' was changed ' .. tostring(device.nValue), domoticz.LOG_INFO)
            -- Send email notification in case level = 4 (or other see user var TH_ALERTTOEMAIL)
	    if (device.nValue == domoticz.variables(IDX_TH_ALERTTOEMAIL).value) then
            domoticz.notify('ALERT:' .. device.text, device.text , domoticz.PRIORITY_HIGH)
		end
	end
}

