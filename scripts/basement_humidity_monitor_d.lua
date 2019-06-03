--~/domoticz/scripts/lua/basement_humidity_monitor_d.lua
-----------------------------------------------------------------------------
-- Monitor the basement humidity if exceeds threshold and write to Domoticz log.
-- project: mysmarthome
-- @interpreter: dzVents, Device
-- @see: readme.txt
-- @author: Robert W.B. Linn
-- @version: 20180902
----------------------------------------------------------------------------- 

-- Thresholds
-- Set the threshold to monitor the humidity (%RH)
local HumidityThreshold = 70;

-- dzVent
return {
	on = {
		devices = {
			'Keller'
		}
	},
	execute = function(domoticz, device)
	    if (device.name == 'Keller' and device.humidity >= HumidityThreshold) then
	        domoticz.log('Basement Humidity >= ' .. HumidityThreshold .. ' (' .. device.humidity .. ')', domoticz.LOG_INFO)
            -- domoticz.notify('Fire', 'The room is on fire', domoticz.PRIORITY_EMERGENCY)
        end
end
}

