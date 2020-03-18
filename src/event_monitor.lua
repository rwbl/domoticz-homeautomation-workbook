--[[
    event_monitor.lua
    Monitor the state change of selected devices (idx) and update the text of the device Event Monitor
    Project: atHome
    Interpreter: dzVents, devices
    See: athome.pdf
    Author: Robert W.B. Linn
    Version: 20190519
]]--

return {
	on = {
		devices = {
            -- list of the idx of the devices monitored
            -- update accordingly
			110,111,112,113,118,
			160,162
		}
	},
	execute = function(domoticz, device)
		-- domoticz.log('Event Monitor: ' .. device.name .. ' changed ' .. device.state, domoticz.LOG_INFO)
		local message = '' .. device.name .. ' changed to ' .. device.state
		domoticz.helpers.eventmonitormsg(domoticz, message)
	end
}
