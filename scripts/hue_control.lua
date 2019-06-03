-- Idx of the devices
local IDX_HUE_MAKELAB = 118;
local IDX_CONTROLMSG = 52

-- Get the current time from the domoticz instance with time object
-- Return time now, i.e. 09:09:00
local function isnowtime(domoticz)
    return domoticz.time.rawTime
end

local function setalertmsg(domoticz, level, msg)
    domoticz.devices(domoticz.variables('IDX_ALERTMSG').value).updateAlertSensor(level, msg)
end

return {
    -- active = true,
	on = {
		devices = {
			IDX_HUE_MAKELAB
		}
	},
	execute = function(domoticz, device)
		domoticz.log('Device ' .. device.name .. ' changed to ' .. device.state, domoticz.LOG_INFO)
		if (device.state == 'On') then
		    device.switchOff()
            local msg = device.name .. ' switched OFF ' .. isnowtime(domoticz)
            setalertmsg(domoticz, domoticz.ALERTLEVEL_GREEN, msg)
		    -- device.dimTo(20)
		    domoticz.variables('DEF_ALERTMSG').set('Hello World')
		    domoticz.log('OK', domoticz.LOG_INFO)
		end
		-- domoticz.log(device.dump(), domoticz.LOG_INFO)
	end
}
